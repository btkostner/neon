defmodule NeonServer.Resolvers.Stock do
  @moduledoc """
  All of the Absinthe resolvers for the Neon.Stock context.
  """

  use NeonServer, :resolver

  alias Neon.Stock

  def get_markets(_parent, args, _resolution) do
    {:ok, Stock.list_markets(args)}
  end

  def get_market(_parent, args, _resolution) do
    {:ok, Stock.get_market(args)}
  end

  def get_symbols(_parent, args, _resolution) do
    {:ok, Stock.list_symbols(args)}
  end

  def get_symbol(_parent, args, _resolution) do
    {:ok, Stock.get_symbol(args)}
  end

  def list_aggregates(_parent, args, _resolution) do
    {:ok, Stock.list_aggregates(args)}
  end

  def last_aggregate(_parent, args, _resolution) do
    aggregate =
      args
      |> Map.put(:limit, 1)
      |> Stock.list_aggregates()
      |> Enum.at(-1)

    {:ok, aggregate}
  end

  def backfill_symbol(_parent, %{symbol_id: symbol_id, days: days}, _resolution) do
    symbol = Stock.get_symbol(id: symbol_id)
    Stock.backfill_aggregate(symbol, days)
  end
end
