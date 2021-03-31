defmodule Neon.Market.Exchange do
  @moduledoc """
  Schema for the different market exchanges
  """

  use Neon, :schema

  alias Neon.Market.Ticker

  schema "market_exchange" do
    field :abbreviation, :string
    field :name, :string

    has_many :tickers, Ticker

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
