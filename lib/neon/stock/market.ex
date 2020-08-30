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
    |> uppercase(:abbreviation)
    |> validate_required([:abbreviation])
  end

  defp uppercase(changeset, field) do
    case get_change(changeset, field) do
      nil -> changeset
      value -> put_change(changeset, field, String.upcase(value))
    end
  end
end
