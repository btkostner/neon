defmodule Neon.Repo.Migrations.AddAccountSessions do
  use Ecto.Migration

  def up do
    create table(:account_sessions, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :ip, :string
      add :user_agent, :string

      add :expired, :bool, default: false, null: false

      add :user_id,
          references(
            :account_users,
            type: :uuid,
            on_delete: :delete_all
          ),
          null: false

      timestamps(updated_at: false)
      add :expired_at, :utc_datetime, null: false
    end
  end

  def down do
    drop table(:account_sessions)
  end
end
