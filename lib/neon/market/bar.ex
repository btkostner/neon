defmodule Neon.Market.Bar do
  @moduledoc """
  Ecto database schema for historical bar data graph data. Each entry
  here is based averaged over 5 minutes.
  """

  use Neon, :schema

  alias Neon.Market.Ticker

  @timestamps_opts [type: :utc_datetime_usec]

  schema "market_bar" do
    field :open_price, :decimal
    field :high_price, :decimal
    field :low_price, :decimal
    field :close_price, :decimal

    field :volume, :integer

    belongs_to :ticker, Ticker
    has_one :exchange, through: [:ticker, :exchange]

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
    |> cast(attrs, @fields ++ [:ticker_id, :inserted_at])
    |> validate_required(@fields)
    |> modulo_inserted_at()
    |> validate_number(:open_price, greater_than_or_equal_to: 0)
    |> validate_number(:high_price, greater_than_or_equal_to: 0)
    |> validate_number(:low_price, greater_than_or_equal_to: 0)
    |> validate_number(:close_price, greater_than_or_equal_to: 0)
    |> validate_number(:volume, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:ticker_id)
    |> unique_constraint([:ticker_id, :inserted_at],
      name: "_hyper_2_1_chunk_market_bar_ticker_id_inserted_at_index"
    )
  end

  defp modulo_inserted_at(changeset) do
    case get_change(changeset, :inserted_at) do
      nil ->
        changeset

      inserted_at ->
        put_change(changeset, :inserted_at, Neon.Time.modulo_date(inserted_at, :before, 5))
    end
  end
end
