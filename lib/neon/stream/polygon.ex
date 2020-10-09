defmodule Neon.Stream.Polygon do
  @moduledoc """
  Socket interface for streaming Polygon stock data.
  """

  use WebSockex

  require Logger

  alias Neon.Live.Symbol
  alias Neon.Stock
  alias Neon.Stream.{Cache, Inserter}

  @url "wss://socket.polygon.io/stocks"

  def start_link(_opts \\ []) do
    WebSockex.start_link(@url, __MODULE__, :no_state, name: __MODULE__)
  end

  def handle_connect(_conn, state) do
    Logger.info("Connected to Polygon")
    authenticate()
    {:ok, state}
  end

  def handle_disconnect(_conn, state) do
    Logger.info("Disconnected from Polygon")
    Cache.clear(__MODULE__)
    {:ok, state}
  end

  def handle_frame({:text, message}, state) do
    message
    |> Jason.decode!()
    |> Enum.each(&handle_stream(Map.get(&1, "ev"), &1))

    {:ok, state}
  rescue
    e -> Logger.error(Exception.message(e))
  end

  def handle_cast({:json, msg}, state) do
    {:reply, {:text, Jason.encode!(msg)}, state}
  end

  def handle_stream("status", %{"message" => "authenticated"}) do
    Logger.debug("Authenticated to Polygon")
    subscribe()
  end

  def handle_stream("A" <> _, data) do
    data
    |> cast_bar()
    |> Symbol.push()
  end

  def handle_stream(_, _), do: :ok

  def authenticate() do
    WebSockex.cast(
      __MODULE__,
      {:json,
       %{
         action: "auth",
         params: Application.get_env(:neon, :alpaca)[:key_id]
       }}
    )
  end

  def subscribe() do
    symbols = Stock.list_symbols()

    Cachex.put_many(Neon.Stream.PolygonCache, Enum.map(symbols, &{&1.symbol, &1.id}))

    symbols
    |> Enum.map(&"A.#{&1.symbol}")
    |> Enum.chunk_every(1000)
    |> Enum.map(&Enum.join(&1, ","))
    |> Enum.each(fn symbols ->
      WebSockex.cast(
        __MODULE__,
        {:json,
         %{
           action: "subscribe",
           params: symbols
         }}
      )
    end)
  end

  defp cast_bar(data) do
    %{
      symbol_id: get_symbol_id(data["sym"]),
      open_price: data["o"],
      high_price: data["h"],
      low_price: data["l"],
      close_price: data["c"],
      volume: data["av"],
      inserted_at: DateTime.from_unix!(data["s"], :millisecond)
    }
  end

  defp get_symbol_id(symbol) do
    case Cachex.get(Neon.Stream.PolygonCache, symbol) do
      {:ok, value} -> value
      _ -> nil
    end
  end
end
