defmodule Neon.Stock.Symbol do
  @moduledoc """
  Schema for each symbol that can be traded. Note that the symbol is not unique
  as it can be used in different markets.
  """

  use Neon.Schema

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
    |> validate_required([:symbol])
    |> validate_length(:symbol, max: 6)
    |> validate_length(:currency, is: 3)
    |> foreign_key_constraint(:market_id)
  end
end
