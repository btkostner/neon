defmodule Neon.Market.Exchange do
  @moduledoc """
  Schema for the different market exchanges
  """

  use Neon, :schema

  @primary_key false
  @derive {Phoenix.Param, key: :abbreviation}

  schema "market_exchange" do
    field :abbreviation, :string, primary_key: true
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(market, attrs) do
    market
    |> cast(attrs, [:abbreviation, :name])
    |> validate_required([:abbreviation])
    |> update_change(:abbreviation, &String.upcase/1)
    |> unique_constraint(:abbreviation, name: "market_exchange_pkey")
  end
end
