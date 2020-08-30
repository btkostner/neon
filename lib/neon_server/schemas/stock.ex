defmodule NeonServer.Schemas.Stock do
  @moduledoc """
  All GraphQL mutations and queries for the Neon.Stock context.
  """

  use NeonServer, :schema

  object :stock_queries do
    @desc "List all of the stock markets"
    field :stock_markets, list_of(:stock_market) do
      arg(:limit, non_null(:integer), default_value: 100)

      resolve &Resolvers.Stock.get_markets/3
    end

    @desc "Get information about a single stock market"
    field :stock_market, :stock_market do
      arg(:id, :id)

      resolve(&Resolvers.Stock.get_market/3)
    end

    @desc "List all of the stock symbols"
    field :stock_symbols, list_of(:stock_symbol) do
      arg(:market_id, :id)
      arg(:market_abbreviation, :string)

      arg(:symbol, :string)

      arg(:limit, non_null(:integer), default_value: 100)

      resolve &Resolvers.Stock.get_symbols/3
    end

    @desc "Get information about a single stock symbol"
    field :stock_symbol, :stock_symbol do
      arg(:market_id, :id)
      arg(:market_abbreviation, :string)

      arg(:id, :id)
      arg(:symbol, :string)

      resolve(&Resolvers.Stock.get_symbol/3)
    end

    @desc "List stock price aggregates"
    field :stock_aggregates, list_of(:stock_aggregate) do
      arg(:symbol_id, :id)

      arg(:from, :datetime)
      arg(:to, :datetime)
      arg(:width, non_null(:string), default_value: "5 minutes")

      arg(:limit, non_null(:integer), default_value: 1000)

      resolve(&Resolvers.Stock.list_aggregates/3)
    end
  end

  object :stock_subscriptions do
    @desc "Subscribe to changes in stock aggregate data"
    field :stock_aggregates, :stock_aggregate do
      arg(:symbol_id, non_null(:id))

      arg(:width, non_null(:string), default_value: "5 minutes")

      config(fn args, _ ->
        {:ok, topic: args.symbol_id}
      end)

      trigger :stock_backfill, topic: fn res ->
        case res do
          [%{symbol_id: symbol_id} | _] -> symbol_id
          _ -> nil
        end
      end

      resolve(&Resolvers.Stock.last_aggregate/3)
    end
  end

  object :stock_mutations do
    @desc "Backfills a stock"
    field :stock_backfill, type: list_of(:stock_aggregate) do
      arg(:symbol_id, non_null(:string))
      arg(:days, non_null(:integer), default_value: 30)

      resolve(&Resolvers.Stock.backfill_symbol/3)
    end
  end
end
