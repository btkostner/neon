defmodule Neon.Market.Ticker do
  @moduledoc """
  Schema for each symbol that can be traded. All tickers are assumed to be traded against USD.
  """

  use Neon, :schema

  alias Neon.Market.{Bar, Exchange}

  @derive {Phoenix.Param, key: :name}

  schema "market_ticker" do
    field :symbol, :string
    field :name, :string

    belongs_to :exchange, Exchange

    has_many :bars, Bar

    timestamps()
  end

  @doc false
  def changeset(symbol, attrs) do
    symbol
    |> cast(attrs, [:symbol, :name, :exchange_id])
    |> uppercase(:symbol)
    |> validate_required([:symbol])
    |> validate_format(:symbol, ~r/^[A-Z]{1,6}$/)
    |> foreign_key_constraint(:exchange_id)
  end

  defp uppercase(changeset, field) do
    case get_change(changeset, field) do
      nil -> changeset
      value -> put_change(changeset, field, String.upcase(value))
    end
  end
end
