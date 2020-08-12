defmodule NeonServer.Schemas.Stock do
  @moduledoc """
  All GraphQL mutations and queries for the Neon.Stock context.
  """

  use NeonServer, :schema

  alias Neon.Stock

  object :stock_queries do
    @desc "List all of the stock markets"
    field :stock_markets, list_of(:stock_market),
      resolve: dataloader(Stock, Stock.Market)

    @desc "Get information about a single stock market"
    field :stock_market, :stock_market do
      arg(:id, non_null(:string))

      resolve(&Resolvers.Stock.get_market/3)
    end

    @desc "List all of the stock symbols"
    field :stock_symbols, list_of(:stock_symbol),
      resolve: dataloader(Stock, Stock.Symbol)

    @desc "Get information about a single stock symbol"
    field :stock_symbol, :stock_symbol do
      arg(:id, non_null(:string))

      resolve(&Resolvers.Stock.get_symbol/3)
    end

    @desc "List stock price aggregates"
    field :stock_aggregates, list_of(:stock_aggregate) do
      arg(:symbol_id, non_null(:string))
      arg(:width, :string)
      arg(:limit, :integer)

      resolve(&Stock.list_aggregates/3)
    end
  end

  object :stock_subscriptions do
    @desc "Subscribe to changes in stock aggregate data"
    field :stock_aggregates, :stock_aggregate do
      arg(:symbol_id, non_null(:string))
      arg(:width, :string)

      config(fn args, _ ->
        {:ok, topic: args.symbol_id}
      end)

      resolve(&Stock.last_aggregate/3)
    end
  end
end
