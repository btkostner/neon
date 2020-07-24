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
end
