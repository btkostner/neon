defmodule Neon.Stock.Symbol do
  @moduledoc """
  Schema for each symbol that can be traded. Note that the symbol is not unique
  as it can be used in different markets.
  """

  use Neon, :schema

  alias Neon.Stock.{Aggregate, Market}

  schema "stock_symbols" do
    field :symbol, :string
    field :name, :string

    field :currency, :string

    belongs_to :market, Market
    has_many :aggregates, Aggregate

    timestamps()
  end

  @doc false
  def changeset(symbol, attrs) do
    symbol
    |> cast(attrs, [:symbol, :name, :currency, :market_id])
    |> uppercase(:symbol)
    |> uppercase(:currency)
    |> validate_required([:symbol])
    |> validate_length(:symbol, max: 6)
    |> validate_length(:currency, is: 3)
    |> foreign_key_constraint(:market_id)
  end

  defp uppercase(changeset, field) do
    case get_change(changeset, field) do
      nil -> changeset
      value -> put_change(changeset, field, String.upcase(value))
    end
  end
end
