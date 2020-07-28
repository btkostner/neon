defmodule NeonServer.Schemas.Stock do
  @moduledoc """
  All GraphQL mutations and queries for the Neon.Stock context.
  """

  use NeonServer, :schema

  alias Neon.Stocks
  alias NeonServer.Resolvers

  object :stock_queries do
    @desc "List stock price aggregates"
    field :aggregates, list_of(:aggregate) do
      arg(:symbol, non_null(:string))
      arg(:width, :string)
      arg(:limit, :integer)

      resolve(&Resolvers.Stock.list_aggregates/3)
    end
  end

  object :stock_subscriptions do
    @desc "Subscribe to changes in stock aggregate data"
    field :aggregate, :aggregate do
      arg(:symbol, non_null(:string))
      arg(:width, :string)

      config(fn args, _ ->
        {:ok, topic: args.symbol}
      end)

      resolve(&Resolvers.Stock.last_aggregate/3)
    end
  end
end
