defmodule Neon.Repo.Migrations.CreateMarketTables do
  use Ecto.Migration

  def change do
    create table(:market_exchange, primary_key: false) do
      add :abbreviation, :string, primary_key: true
      add :name, :string

      timestamps()
    end

    create table(:market_ticker, primary_key: false) do
      add :symbol, :string, primary_key: true
      add :name, :string

      add :exchange_abbreviation,
          references(
            :market_exchange,
            column: :abbreviation,
            type: :string,
            on_delete: :delete_all
          ),
          primary_key: true

      timestamps()
    end

    create table(:market_bar, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :open_price, :decimal
      add :high_price, :decimal
      add :low_price, :decimal
      add :close_price, :decimal

      add :volume, :integer

      add :ticker_symbol,
          references(
            :market_ticker,
            column: :symbol,
            type: :string,
            with: [exchange_abbreviation: :exchange_abbreviation],
            on_delete: :delete_all
          )

      add :exchange_abbreviation, :string

      timestamps(
        updated_at: false,
        primary_key: true,
        type: :utc_datetime_usec
      )
    end

    execute("SELECT create_hypertable('market_bar', 'inserted_at')")

    create unique_index(:market_bar, [:ticker_symbol, :exchange_abbreviation, :inserted_at])
  end
end
