defmodule Mix.Tasks.Accounts.CreateUser do
  @moduledoc """
  Creates a new user account.
  """

  use Mix.Task

  require Logger

  alias Neon.Accounts.User
  alias Neon.Repo

  @start_apps [
    :postgrex,
    :ecto,
    :ecto_sql
  ]

  def run([name, email]) do
    run([name, email, :user])
  end

  def run([name, email, role]) do
    run([name, email, role, random_string(32)])
  end

  def run([name, email, role, password]) do
    start_services()

    user =
      %User{}
      |> User.changeset(%{name: name, email: email, password: password})
      |> Ecto.Changeset.put_change(:role, role)
      |> Repo.insert!()

    Mix.shell().info("Created #{user.email} with password \"#{password}\"")
  end

  defp random_string(length) do
    length
    |> div(2)
    |> :crypto.strong_rand_bytes()
    |> Base.encode16(case: :lower)
  end

  defp start_services() do
    Enum.each(@start_apps, &Application.ensure_all_started/1)
    Repo.start_link()
  end
end
