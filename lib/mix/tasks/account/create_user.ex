defmodule Mix.Tasks.Account.CreateUser do
  @moduledoc """
  Creates a new user account.
  """

  use Mix.Task

  require Logger

  alias Neon.Account

  def run([name, email]) do
    run([name, email, :user])
  end

  def run([name, email, role]) do
    run([name, email, role, random_string(32)])
  end

  @shortdoc "Creates a new user"
  def run([name, email, role, password]) do
    start_services()

    user =
      Account.create_user(%{
        name: name,
        email: email,
        password: password,
        role: role
      })

    Mix.shell().info("Created #{user.email} with password \"#{password}\"")
  end

  defp random_string(length) do
    length
    |> div(2)
    |> :crypto.strong_rand_bytes()
    |> Base.encode16(case: :lower)
  end

  defp start_services(), do: Mix.Task.run("app.start")
end
