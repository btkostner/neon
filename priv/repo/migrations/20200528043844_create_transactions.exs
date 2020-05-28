defmodule Neon.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def up do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :symbol, :string
      add :amount, :float
      add :price, :decimal

      timestamps(
        updated_at: false,
        primary_key: true
      )
    end

    execute("SELECT create_hypertable('transactions', 'inserted_at')")

    create index(:transactions, [:symbol, :inserted_at])
  end

  def down do
    drop table(:transactions)
  end
end
