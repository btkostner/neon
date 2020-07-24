defmodule NeonServer.Types.Stock do
  @moduledoc """
  GraphQL objects for the Neon.Stocks context.
  """

  use NeonServer, :schema

  object :aggregate do
    field :symbol, :string

    field :open_price, :decimal
    field :high_price, :decimal
    field :low_price, :decimal
    field :close_price, :decimal

    field :volume, :integer

    field :inserted_at, :datetime do
      resolve(fn data, _, _ ->
        DateTime.from_naive(data.inserted_at, "Etc/UTC")
      end)
    end
  end
end
