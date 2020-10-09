defmodule Neon.Stream.Alpaca do
  @moduledoc """
  Socket interface for streaming Alpaca stock data.
  """

  use WebSockex

  require Logger

  alias Neon.Live.Symbol
  alias Neon.Stock
  alias Neon.Stream.{Cache, Inserter}

  @url "wss://data.alpaca.markets/stream"
  @markets ["AMEX", "ARCA", "BATS", "NYSE", "NASDAQ", "NYSEARCA"]

  def start_link(_opts \\ []) do
    WebSockex.start_link(@url, __MODULE__, :no_state, name: __MODULE__)
  end

  def handle_connect(_conn, state) do
    Logger.info("Connected to Alpaca")
    authenticate()
    {:ok, state}
  end

  def handle_disconnect(_conn, state) do
    Logger.info("Disconnected from Alpaca")
    Cache.clear(__MODULE__)
    {:ok, state}
  end

  def handle_frame({:text, message}, state) do
    body = Jason.decode!(message)
    handle_stream(body["stream"], body["data"])

    {:ok, state}
  rescue
    e -> Logger.error(Exception.message(e))
  end

  def handle_cast({:json, msg}, state) do
    {:reply, {:text, Jason.encode!(msg)}, state}
  end

  def handle_stream("authorization", %{"status" => "authorized"}) do
    Logger.debug("Authenticated to Alpaca")
    subscribe()
  end

  def handle_stream("listening", %{"streams" => streams}) do
    Logger.debug("Streaming #{length(streams)} symbols from Alpaca")
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
         action: "authenticate",
         data: %{
           key_id: Application.get_env(:neon, :alpaca)[:key_id],
           secret_key: Application.get_env(:neon, :alpaca)[:secret_key]
         }
       }}
    )
  end

  def subscribe() do
    symbols = Stock.list_symbols(market_abbreviation: @markets)

    Cachex.put_many(Neon.Stream.AlpacaCache, Enum.map(symbols, &{&1.symbol, &1.id}))

    symbols
    |> Enum.map(fn s -> "AM.#{s.symbol}" end)
    |> Enum.chunk_every(1000)
    |> Enum.each(fn symbols ->
      WebSockex.cast(
        __MODULE__,
        {:json,
         %{
           action: "listen",
           data: %{
             streams: symbols
           }
         }}
      )
    end)
  end

  defp cast_bar(data) do
    %{
      symbol_id: get_symbol_id(data["T"]),
      open_price: data["o"],
      high_price: data["h"],
      low_price: data["l"],
      close_price: data["c"],
      volume: data["v"],
      inserted_at: DateTime.from_unix!(data["s"], :millisecond)
    }
  end

  defp get_symbol_id(symbol) do
    case Cachex.get(Neon.Stream.AlpacaCache, symbol) do
      {:ok, value} -> value
      _ -> nil
    end
  end
end
