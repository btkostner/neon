defmodule Neon.Repo.Migrations.CreateMarketTables do
  use Ecto.Migration

  def change do
    create table(:market_exchange, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :abbreviation, :string, null: false
      add :name, :string

      timestamps()
    end

    create table(:market_ticker, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :symbol, :string
      add :name, :string

      add :exchange_id,
          references(
            :market_exchange,
            type: :uuid,
            on_delete: :delete_all
          ),
          null: false

      timestamps()
    end

    create table(:market_bar, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :open_price, :decimal
      add :high_price, :decimal
      add :low_price, :decimal
      add :close_price, :decimal

      add :volume, :integer

      add :ticker_id,
          references(
            :market_ticker,
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

    execute("SELECT create_hypertable('market_bar', 'inserted_at')")

    create unique_index(:market_bar, [:ticker_id, :inserted_at])
  end
end
