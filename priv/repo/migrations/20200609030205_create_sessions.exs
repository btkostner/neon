defmodule Neon.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :user_id, references(:users, type: :binary_id), null: false

      add :ip, :string
      add :user_agent, :string

      timestamps(updated_at: false)
      add :expired_at, :utc_datetime, null: false
    end
  end
end
