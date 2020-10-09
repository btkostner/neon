defmodule Neon.Stock.Aggregate do
  @moduledoc """
  Ecto database schema for historical bar data graph data on stocks. Each entry
  here is based averaged over 5 minutes.
  """

  use Neon, :schema

  alias Neon.Stock.Symbol
  alias Neon.Util

  @timestamps_opts [type: :utc_datetime_usec]

  schema "stock_aggregates" do
    field :open_price, :decimal
    field :high_price, :decimal
    field :low_price, :decimal
    field :close_price, :decimal

    field :volume, :integer

    field :records, :integer, virtual: true, default: 1

    belongs_to :symbol, Symbol
    has_one :market, through: [:symbol, :market]

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
    |> cast(attrs, @fields ++ [:symbol_id, :inserted_at])
    |> validate_required(@fields)
    |> modulo_inserted_at()
    |> validate_number(:open_price, greater_than_or_equal_to: 0)
    |> validate_number(:high_price, greater_than_or_equal_to: 0)
    |> validate_number(:low_price, greater_than_or_equal_to: 0)
    |> validate_number(:close_price, greater_than_or_equal_to: 0)
    |> validate_number(:volume, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:symbol_id)
    |> unique_constraint([:symbol_id, :inserted_at],
      name: "_hyper_2_1_chunk_stocks_aggregate_symbol_id_inserted_at_index"
    )
  end

  defp modulo_inserted_at(changeset) do
    case get_change(changeset, :inserted_at) do
      nil ->
        changeset

      inserted_at ->
        put_change(changeset, :inserted_at, Util.modulo_date(inserted_at, :before))
    end
  end
end
