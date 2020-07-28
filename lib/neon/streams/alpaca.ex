defmodule Neon.Streams.Alpaca do
  @moduledoc """
  Socket interface for streaming Alpaca stock data.
  """
  use WebSockex

  import Ecto.Query

  require Logger

  alias Neon.{Stocks, Repo}

  @url "wss://data.alpaca.markets/stream"

  def start_link(_opts \\ []) do
    {:ok, pid} = WebSockex.start_link(@url, __MODULE__, :no_state)

    # :sys.trace(pid, true)

    authenticate(pid)
    subscribe(pid)

    {:ok, pid}
  end

  def handle_connect(_conn, state) do
    Logger.debug("Connected to Alpaca")
    {:ok, state}
  end

  def handle_disconnect(_conn, state) do
    Logger.debug("Disconnected from Alpaca")
    {:ok, state}
  end

  def authenticate(pid) do
    WebSockex.send_frame(
      pid,
      {:text,
       Jason.encode!(%{
         action: "authenticate",
         data: %{
           key_id: Application.get_env(:neon, :alpaca)[:key_id],
           secret_key: Application.get_env(:neon, :alpaca)[:secret_key]
         }
       })}
    )
  end

  def subscribe(pid) do
    symbols =
      Stocks.Aggregate
      |> select([a], a.symbol)
      |> distinct(true)
      |> Repo.all()
      |> Enum.map(fn s -> "AM.#{s}" end)

    WebSockex.send_frame(
      pid,
      {:text,
       Jason.encode!(%{
         action: "listen",
         data: %{
           streams: symbols
         }
       })}
    )
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

  def handle_stream("authorization", %{"status" => "authorized"}, state) do
    Logger.debug("Authenticated to Alpaca")
    {:ok, state}
  end

  def handle_stream("listening", %{"streams" => streams}, state) do
    for stream <- streams do
      Logger.debug("Streaming #{stream} from Alpaca")
    end

    {:ok, state}
  end

  def handle_stream("AM." <> symbol, data, state) do
    Logger.debug("New Aggregate from Alpaca #{symbol}: #{inspect(data)}")

    data
    |> cast_bar()
    |> Neon.Stocks.create_aggregate()

    {:ok, state}
  end

  def handle_stream(stream, data, state) do
    Logger.debug("Data from Alpaca stream #{stream}: #{inspect(data)}")
    {:ok, state}
  end

  defp cast_bar(data) do
    %{
      symbol: String.upcase(data["T"]),
      open_price: data["o"],
      high_price: data["h"],
      low_price: data["l"],
      close_price: data["c"],
      volume: data["v"],
      inserted_at: DateTime.from_unix!(data["s"], :millisecond)
    }
  end
end
