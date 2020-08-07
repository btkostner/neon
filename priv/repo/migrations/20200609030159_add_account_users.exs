defmodule Neon.Repo.Migrations.AddAccountUsers do
  use Ecto.Migration

  def up do
    create table(:account_users, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :name, :string
      add :email, :string

      add :password_hash, :string

      add :role, :string

      timestamps()
    end

    create unique_index(:account_users, [:email])
  end

  def down do
    drop table(:account_users)
  end
end
