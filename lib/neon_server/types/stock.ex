defmodule NeonServer.Types.Stock do
  @moduledoc """
  GraphQL objects for the Neon.Stock context.
  """

  use NeonServer, :schema

  object :stock_market do
    field :abbreviation, :string
    field :name, :string
  end

  object :stock_symbol do
    field :symbol, :string
    field :name, :string

    field :currency, :string

    field :market, :stock_market
  end

  object :stock_aggregate do
    field :open_price, :decimal
    field :high_price, :decimal
    field :low_price, :decimal
    field :close_price, :decimal

    field :volume, :integer

    field :symbol, :stock_symbol

    field :inserted_at, :datetime do
      resolve(fn data, _, _ ->
        DateTime.from_naive(data.inserted_at, "Etc/UTC")
      end)
    end
  end
end
