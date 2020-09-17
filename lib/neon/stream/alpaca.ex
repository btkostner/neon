defmodule Neon.Stream.Alpaca do
  @moduledoc """
  Socket interface for streaming Alpaca stock data.
  """

  use WebSockex

  require Logger

  alias Neon.Stock
  alias Neon.Stream.{Cache, Inserter}

  @url "wss://data.alpaca.markets/stream"
  @markets ["AMEX", "ARCA", "BATS", "NYSE", "NASDAQ", "NYSEARCA"]

  def start_link(_opts \\ []) do
    WebSockex.start_link(@url, __MODULE__, :no_state, name: __MODULE__)
  end

  def handle_connect(_conn, state) do
    Logger.debug("Connected to Alpaca")
    authenticate()
    {:ok, state}
  end

  def handle_disconnect(_conn, state) do
    Logger.debug("Disconnected from Alpaca")
    Cache.clear(__MODULE__)
    {:ok, state}
  end

  def handle_frame({:text, message}, state) do
    body = Jason.decode!(message)
    handle_stream(body["stream"], body["data"], state)
  rescue
    e -> Logger.error(Exception.message(e))
  end

  def handle_cast({:json, msg}, state) do
    {:reply, {:text, Jason.encode!(msg)}, state}
  end

  def handle_stream("authorization", %{"status" => "authorized"}, state) do
    Logger.debug("Authenticated to Alpaca")
    subscribe()
    {:ok, state}
  end

  def handle_stream("listening", %{"streams" => streams}, state) do
    Logger.debug("Streaming #{length(streams)} symbols from Alpaca")
    {:ok, state}
  end

  def handle_stream("AM." <> symbol, data, state) do
    Logger.debug("New Aggregate from Alpaca #{symbol}: #{inspect(data)}")

    data
    |> cast_bar()
    |> Inserter.insert()

    {:ok, state}
  end

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

    Cache.set(__MODULE__, Enum.map(symbols, &[&1.symbol, &1.id]))

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
      symbol_id: Cache.get(__MODULE__, data["T"]),
      open_price: data["o"],
      high_price: data["h"],
      low_price: data["l"],
      close_price: data["c"],
      volume: data["v"],
      inserted_at: DateTime.from_unix!(data["s"], :millisecond)
    }
  end
end
