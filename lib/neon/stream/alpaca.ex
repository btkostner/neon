defmodule Neon.Stream.Alpaca do
  @moduledoc """
  Socket interface for streaming Alpaca stock data.
  """

  use WebSockex

  import Ecto.Query

  require Logger

  alias Neon.{Stock, Repo}

  @url "wss://data.alpaca.markets/stream"
  @markets ["AMEX", "ARCA", "BATS", "NYSE", "NASDAQ", "NYSEARCA"]

  def start_link(_opts \\ []) do
    {:ok, pid} = WebSockex.start_link(@url, __MODULE__, :no_state)

    # :sys.trace(pid, true)

    {:ok, pid}
  end

  def handle_connect(_conn, state) do
    Logger.debug("Connected to Alpaca")
    authenticate()
    {:ok, state}
  end

  def handle_disconnect(_conn, state) do
    Logger.debug("Disconnected from Alpaca")
    {:ok, state}
  end

  def handle_frame({:text, message}, state) do
    body = Jason.decode!(message)
    handle_stream(body["stream"], body["data"], state)
  rescue
    e -> Logger.error(Exception.message(e))
  end

  def handle_frame(frame, state) do
    Logger.warn("Unknown data from Alpaca: #{inspect(frame)}")
    {:ok, state}
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
    Enum.each(streams, &Logger.debug("Streaming #{&1} from Alpaca"))
    {:ok, state}
  end

  def handle_stream("AM." <> symbol, data, state) do
    Logger.debug("New Aggregate from Alpaca #{symbol}: #{inspect(data)}")

    data
    |> cast_bar()
    |> Stock.create_aggregate()

    {:ok, state}
  end

  def handle_stream(stream, data, state) do
    Logger.debug("Data from Alpaca stream #{stream}: #{inspect(data)}")
    {:ok, state}
  end

  def authenticate() do
    WebSockex.cast(
      self(),
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
    symbols = Enum.map(get_symbols(), fn s -> "AM.#{s}" end)

    if length(symbols) != 0 do
      WebSockex.cast(
        self(),
        {:json,
         %{
           action: "listen",
           data: %{
             streams: symbols
           }
         }}
      )
    end
  end

  defp cast_bar(data) do
    symbol_id = get_symbol_id(String.upcase(data["T"]))

    %{
      symbol_id: symbol_id,
      open_price: data["o"],
      high_price: data["h"],
      low_price: data["l"],
      close_price: data["c"],
      volume: data["v"],
      inserted_at: DateTime.from_unix!(data["s"], :millisecond)
    }
  end

  defp get_symbols() do
    query =
      from s in Stock.Symbol,
        select: [s.symbol],
        join: m in assoc(s, :market),
        where: m.abbreviation in @markets

    Repo.all(query)
  end

  defp get_symbol_id(symbol) do
    query =
      from s in Stock.Symbol,
        select: [s.id],
        join: m in assoc(s, :market),
        where: m.abbreviation in @markets,
        where: s.symbol == ^symbol,
        limit: 1

    Repo.one(query)
  end
end
