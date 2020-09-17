defmodule Mix.Tasks.Service.AlpacaImport do
  @moduledoc """
  Imports all of the trade symbols from Alpaca
  """

  use Mix.Task

  require Logger

  alias Neon.Service.Alpaca
  alias Neon.Stock

  def run(_) do
    Mix.Task.run("app.start")

    {:ok, assets} = Alpaca.get_assets()

    active_assets =
      assets
      |> Enum.filter(&Map.get(&1, "tradable", false))
      |> Enum.filter(&(Map.get(&1, "status") == "active"))

    Logger.debug("Fetched #{length(active_assets)} assets from Alpaca")

    markets = upsert_markets(active_assets)
    symbols = upsert_symbols(active_assets, markets)

    Logger.info("Inserted #{length(symbols)} symbols from Alpaca")
  end

  def upsert_markets(assets) do
    markets = Stock.list_markets()
    market_abbreviations = enum_map_take(markets, :abbreviation)

    assets
    |> enum_map_take("exchange")
    |> Enum.filter(&(&1 not in market_abbreviations))
    |> Enum.uniq()
    |> Enum.map(&Map.put(%{}, :abbreviation, &1))
    |> Enum.map(&Stock.create_market/1)
    |> Enum.reject(&(elem(&1, 0) == :error))
    |> Enum.map(&elem(&1, 1))
    |> Enum.concat(markets)
  end

  def upsert_symbols(assets, markets) when is_list(assets) do
    assets
    |> Enum.map(&upsert_symbols(&1, markets))
    |> Enum.reject(&(elem(&1, 0) == :error))
    |> Enum.map(&elem(&1, 1))
  end

  def upsert_symbols(asset, markets) do
    market_id =
      markets
      |> Enum.find(%{}, &(&1.abbreviation == asset["exchange"]))
      |> Map.get(:id)

    Stock.create_symbol(%{
      id: asset["id"],
      symbol: asset["symbol"],
      name: asset["name"],
      currency: "USD",
      market_id: market_id
    })
  end

  defp enum_map_take(enum, key),
    do: Enum.map(enum, &Map.get(&1, key))
end
