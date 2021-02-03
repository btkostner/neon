defmodule Neon.Repo.Migrations.AddTwoFactorFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :backup_codes, {:array, :string}, default: []
      add :two_factor_seed, :string
    end
  end
end
