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

  def list_users(_parent, _args, _resolution) do
    {:ok, Account.list_users()}
  end

  def login(_parent, args, _resolution) do
    Account.login_user(args)
  end

  def register(_parent, args, _resolution) do
    Account.register_user(args)
  end
end
