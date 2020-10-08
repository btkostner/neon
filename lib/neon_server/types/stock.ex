defmodule NeonServer.Types.Stock do
  @moduledoc """
  GraphQL objects for the Neon.Stock context.
  """

  use NeonServer, :schema

  alias Neon.Stock

  object :stock_market do
    field :id, :id

    field :abbreviation, :string
    field :name, :string

    field :symbols, list_of(:stock_symbol) do
      arg(:limit, :integer, default_value: 100)

      resolve(dataloader(Stock))
    end
  end

  object :stock_symbol do
    field :id, :id

    field :symbol, :string
    field :name, :string

    field :currency, :string

    field :market, :stock_market, resolve: dataloader(Stock)

    field :aggregates, list_of(:stock_aggregate) do
      arg(:from, :datetime)
      arg(:to, :datetime)
      arg(:width, :string, default_value: "5 minutes")

      arg(:limit, :integer, default_value: 1000)

      resolve(dataloader(Stock))
    end
  end

  object :stock_aggregate do
    field :id, :id

    field :open_price, :decimal
    field :high_price, :decimal
    field :low_price, :decimal
    field :close_price, :decimal

    field :volume, :integer

    field :records, :integer

    field :symbol, :stock_symbol, resolve: dataloader(Stock)

    field :inserted_at, :datetime do
      resolve(fn data, _, _ ->
        DateTime.from_naive(data.inserted_at, "Etc/UTC")
      end)
    end
  end
end
