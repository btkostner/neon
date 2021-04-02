defmodule Neon.Market.Ticker do
  @moduledoc """
  Schema for each symbol that can be traded. All tickers are assumed to be traded against USD.
  """

  use Neon, :schema

  @primary_key false
  @derive {Phoenix.Param, key: :symbol}

  schema "market_ticker" do
    field :symbol, :string, primary_key: true
    field :name, :string

    field :exchange_abbreviation, :string

    timestamps()
  end

  @doc false
  def changeset(symbol, attrs) do
    symbol
    |> cast(attrs, [:symbol, :name, :exchange_abbreviation])
    |> validate_required([:symbol, :exchange_abbreviation])
    |> validate_format(:symbol, ~r/^[A-Z\-\.]{1,7}$/)
    |> update_change(:symbol, &String.upcase/1)
    |> unique_constraint([:symbol, :exchange_abbreviation], name: "market_ticker_pkey")
    |> foreign_key_constraint(:exchange_abbreviation,
      name: "market_ticker_exchange_abbreviation_fkey"
    )
  end
end
