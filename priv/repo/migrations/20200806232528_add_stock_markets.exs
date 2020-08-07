defmodule Neon.Repo.Migrations.AddStockMarkets do
  use Ecto.Migration

  def up do
    create table(:stock_markets, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :abbreviation, :string, null: false
      add :name, :string

      timestamps()
    end
  end

  def down do
    drop table(:stock_markets)
  end
end
