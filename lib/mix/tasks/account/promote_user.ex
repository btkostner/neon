defmodule Mix.Tasks.Account.PromoteUser do
  @moduledoc """
  Sets a user's role.
  """

  use Mix.Task

  require Logger

  alias Neon.Account

  def run([email]) do
    run([email, :admin])
  end

  @shortdoc "Sets a user's role"
  def run([email, role]) do
    start_services()

    {:ok, user} =
      email
      |> Account.get_user_by_email!()
      |> Account.update_user(%{role: role_atom(role)})

    Mix.shell().info("Updated #{user.email} with role of #{user.role}")
  end

  defp role_atom(string) do
    case string do
      "admin" -> :admin
      "user" -> :user
      _ -> ""
    end
  end

  defp start_services(), do: Mix.Task.run("app.start")
end
