defmodule NeonServer.Resolvers.Stock do
  @moduledoc """
  All of the Absinthe resolvers for the Neon.Stock context.
  """

  alias Neon.Stocks

  def list_aggregates(_parent, %{symbol: symbol} = args, _resolution) do
    aggregates = Stocks.list_aggregates(symbol, Neon.Util.to_keyword_list(args))
    {:ok, aggregates}
  end

  def last_aggregate(_parent, %{symbol: symbol} = args, _resolution) do
    aggregate = Stocks.last_aggregate(symbol, Neon.Util.to_keyword_list(args))
    {:ok, aggregate}
  end
end
