defmodule Neon.Repo.Migrations.AddStockAggregates do
  use Ecto.Migration

  def up do
    create table(:stock_aggregates, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :open_price, :decimal
      add :high_price, :decimal
      add :low_price, :decimal
      add :close_price, :decimal

      add :volume, :integer

      add :symbol_id,
          references(
            :stock_symbols,
            type: :uuid,
            on_delete: :delete_all
          ),
          null: false

      timestamps(
        updated_at: false,
        primary_key: true,
        type: :utc_datetime_usec
      )
    end

    execute("SELECT create_hypertable('stock_aggregates', 'inserted_at')")

    create unique_index(:stock_aggregates, [:symbol_id, :inserted_at])
  end

  def down do
    drop table(:stock_aggregates)
  end
end
