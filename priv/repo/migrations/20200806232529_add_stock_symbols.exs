defmodule Neon.Repo.Migrations.AddStockSymbols do
  use Ecto.Migration

  def up do
    create table(:stock_symbols, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :symbol, :string
      add :name, :string

      add :currency, :string, size: 3

      add :market_id,
          references(
            :stock_markets,
            type: :uuid,
            on_delete: :delete_all
          ),
          null: false

      timestamps()
    end
  end

  def down do
    drop table(:stock_symbols)
  end
end
