defmodule Neon.Service.Alpaca do
  @moduledoc """
  Third party API module for Alpaca.
  """

  use Tesla

  alias Neon.Stock

  plug Tesla.Middleware.Headers, [
    {"APCA-API-KEY-ID", Application.get_env(:neon, :alpaca)[:key_id]},
    {"APCA-API-SECRET-KEY", Application.get_env(:neon, :alpaca)[:secret_key]}
  ]

  plug Tesla.Middleware.JSON

  def get_assets() do
    query = [
      status: "active",
      tradable: true
    ]

    case get("https://paper-api.alpaca.markets/v2/assets", query: query) do
      {:ok, response} ->
        {:ok, response.body}

      res ->
        res
    end
  end

  def get_asset(id) do
    case get("https://paper-api.alpaca.markets/v2/assets/#{id}") do
      {:ok, response} ->
        {:ok, response.body}

      res ->
        res
    end
  end

  @doc """
  Grabs aggregated information from Alpaca.

  ## Examples

      iex> get_aggregated(%Symbol{}, limit: 60)
      [%{}]

  """
  def get_aggregated(symbol, opts \\ []) do
    query = [
      symbols: String.upcase(symbol.symbol),
      limit: Keyword.get(opts, :limit, 1000),
      start: format_datetime(Keyword.get(opts, :start)),
      after: format_datetime(Keyword.get(opts, :after))
    ]

    case get("https://data.alpaca.markets/v1/bars/5Min", query: query) do
      {:ok, response} ->
        list =
          response.body
          |> Map.get(String.upcase(symbol.symbol), [])
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
      symbol_id: symbol.id,
      open_price: data["o"],
      high_price: data["h"],
      low_price: data["l"],
      close_price: data["c"],
      volume: data["v"],
      inserted_at: DateTime.from_unix!(data["t"])
    }
  end
end
