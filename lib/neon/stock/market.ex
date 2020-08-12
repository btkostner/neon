defmodule Neon.Stock.Market do
  @moduledoc """
  Schema for the different stock markets.
  """

  use Neon, :schema

  alias Neon.Stock.Symbol

  schema "stock_markets" do
    field :abbreviation, :string
    field :name, :string

    has_many :symbols, Symbol

    timestamps()
  end

  @doc false
  def changeset(market, attrs) do
    market
    |> cast(attrs, [:abbreviation, :name])
    |> validate_required([:abbreviation])
  end
end
