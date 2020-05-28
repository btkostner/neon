defmodule Neon.Trades.Transaction do
  @moduledoc """
  A huge database storage of all the transactions we have ever recorded.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "transactions" do
    field :amount, :float
    field :price, :decimal
    field :symbol, :string

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:symbol, :amount, :price])
    |> validate_required([:symbol, :amount, :price])
  end
end
