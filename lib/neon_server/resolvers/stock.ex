defmodule NeonServer.Resolvers.Stock do
  @moduledoc """
  All of the Absinthe resolvers for the Neon.Stock context.
  """

  use NeonServer, :resolver

  alias Neon.Stock

  def get_market(_parent, %{id: id}, _resolution) do
    {:ok, Stock.get_market(id)}
  end

  def get_symbol(_parent, %{id: id}, _resolution) do
    {:ok, Stock.get_symbol(id)}
  end

  def list_aggregates(_parent, %{symbol_id: symbol_id} = args, _resolution) do
    opts = Neon.Util.to_keyword_list(args)
    aggregates = Stock.list_aggregates(%{symbol_id: symbol_id}, opts)
    {:ok, aggregates}
  end

  def last_aggregate(_parent, %{symbol_id: symbol_id} = args, _resolution) do
    opts = Neon.Util.to_keyword_list(args)
    aggregate = Stock.last_aggregate(%{symbol_id: symbol_id}, opts)
    {:ok, aggregate}
  end
end
