defmodule Neon.Repo.Migrations.CreateBars do
  use Ecto.Migration

  def up do
    create table(:stocks_aggregates, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :symbol, :string

      add :open_price, :decimal
      add :high_price, :decimal
      add :low_price, :decimal
      add :close_price, :decimal

      add :volume, :integer

      timestamps(
        updated_at: false,
        primary_key: true,
        type: :utc_datetime_usec
      )
    end

    execute("SELECT create_hypertable('stocks_aggregates', 'inserted_at')")

    create unique_index(:stocks_aggregates, [:symbol, :inserted_at])
  end

  def down do
    drop table(:stocks_aggregates)
  end
end
