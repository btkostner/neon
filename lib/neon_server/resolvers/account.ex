defmodule NeonServer.Resolvers.Account do
  @moduledoc """
  All of the Absinthe resolvers for the Neon.Account context.
  """

  use NeonServer, :resolver

  alias Neon.Account

  def show_profile(_parent, _args, %{context: %{session_id: session_id}}) do
    session = Account.get_session!(session_id)
    {:ok, session.user}
  end

  def show_profile(_parent, _args, _resolution), do: {:error, :unauthenticated}

  def list_users(_parent, _args, %{context: %{user_role: :admin}}) do
    {:ok, Account.list_users()}
  end

  def list_users(_parent, _args, _resolution), do: {:error, :unauthenticated}

  def login(_parent, args, _resolution) do
    Account.login_user(args)
  end

  def register(_parent, args, _resolution) do
    case Application.get_env(:neon, Account)[:allow_registration] do
      true -> Account.register_user(args)
      false -> {:error, "Registration is disabled"}
    end
  end
end
