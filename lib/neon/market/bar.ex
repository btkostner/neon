defmodule Neon.Market.Bar do
  @moduledoc """
  Ecto database schema for historical bar data graph data. Each entry
  here is based averaged over 5 minutes.
  """

  use Neon, :schema

  @timestamps_opts [type: :utc_datetime_usec]

  schema "market_bar" do
    field :open_price, :decimal
    field :high_price, :decimal
    field :low_price, :decimal
    field :close_price, :decimal

    field :volume, :integer

    field :ticker_symbol, :string
    field :exchange_abbreviation, :string

    timestamps(updated_at: false)
  end

  @fields ~w(
    open_price
    high_price
    low_price
    close_price

    volume
  )a

  @doc false
  def changeset(aggregate, attrs) do
    aggregate
    |> cast(attrs, @fields ++ [:ticker_symbol, :exchange_abbreviation, :inserted_at])
    |> validate_required(@fields ++ [:ticker_symbol, :exchange_abbreviation])
    |> update_change(:inserted_at, &Neon.Time.modulo_date(&1, :before, 5))
    |> validate_number(:open_price, greater_than_or_equal_to: 0)
    |> validate_number(:high_price, greater_than_or_equal_to: 0)
    |> validate_number(:low_price, greater_than_or_equal_to: 0)
    |> validate_number(:close_price, greater_than_or_equal_to: 0)
    |> validate_number(:volume, greater_than_or_equal_to: 0)
    |> unique_constraint([:ticker_symbol, :exchange_abbreviation, :inserted_at],
      name: "market_bar_ticker_symbol_exchange_abbreviation_inserted_at_inde"
    )
    |> foreign_key_constraint([:ticker_symbol, :exchange_abbreviation],
      name: "market_bar_ticker_symbol_fkey"
    )
  end
end
