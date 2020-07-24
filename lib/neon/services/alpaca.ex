defmodule Neon.Services.Alpaca do
  @moduledoc """
  Third party API module for Alpaca.
  """

  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://data.alpaca.markets"

  plug Tesla.Middleware.Headers, [
    {"APCA-API-KEY-ID", Application.get_env(:neon, :alpaca)[:key_id]},
    {"APCA-API-SECRET-KEY", Application.get_env(:neon, :alpaca)[:secret_key]}
  ]

  plug Tesla.Middleware.JSON

  def get_aggregated(symbol, opts \\ []) do
    query = [
      symbols: String.upcase(symbol),
      limit: Keyword.get(opts, :limit, 1000),
      start: format_datetime(Keyword.get(opts, :start)),
      after: format_datetime(Keyword.get(opts, :after))
    ]

    case get("/v1/bars/5Min", query: query) do
      {:ok, response} ->
        list =
          response.body
          |> Map.get(String.upcase(symbol), [])
          |> cast_bars(symbol)

        {:ok, list}

      res ->
        res
    end
  end

  defp format_datetime(nil), do: nil
  defp format_datetime(datetime), do: DateTime.to_iso8601(datetime, :extended)

  defp cast_bars(data, symbol) when is_list(data) do
    Enum.map(data, &cast_bars(&1, symbol))
  end

  defp cast_bars(data, symbol) do
    %{
      symbol: String.upcase(symbol),
      open_price: data["o"],
      high_price: data["h"],
      low_price: data["l"],
      close_price: data["c"],
      volume: data["v"],
      inserted_at: DateTime.from_unix!(data["t"])
    }
  end
end
