defmodule Neon.Stocks.Aggregate do
  @moduledoc """
  Ecto database schema for historical bar data graph data on stocks. Each entry
  here is based averaged over 5 minutes.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]

  schema "stocks_aggregates" do
    field :symbol, :string

    field :open_price, :decimal
    field :high_price, :decimal
    field :low_price, :decimal
    field :close_price, :decimal

    field :volume, :integer

    timestamps(updated_at: false)
  end

  @fields ~w(
    symbol

    open_price
    high_price
    low_price
    close_price

    volume
  )a

  @doc false
  def changeset(aggregate, attrs) do
    aggregate
    |> cast(attrs, @fields ++ [:inserted_at])
    |> validate_required(@fields)
    |> validate_length(:symbol, max: 5)
    |> validate_number(:open_price, greater_than_or_equal_to: 0)
    |> validate_number(:high_price, greater_than_or_equal_to: 0)
    |> validate_number(:low_price, greater_than_or_equal_to: 0)
    |> validate_number(:close_price, greater_than_or_equal_to: 0)
    |> validate_number(:volume, greater_than_or_equal_to: 0)
    |> unique_constraint([:symbol, :inserted_at], name: "_hyper_2_1_chunk_stocks_aggregate_symbol_inserted_at_index")
  end
end
