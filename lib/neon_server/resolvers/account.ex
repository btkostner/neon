defmodule NeonServer.Resolvers.Account do
  @moduledoc """
  All of the Absinthe resolvers for the Neon.Account context.
  """

  alias Neon.Accounts

  def show_profile(_parent, _args, _resolution) do
    {:ok,
     %{
       name: "Blake Kostner",
       email: "btkostner@gmail.com",
       role: :admin
     }}
  end

  def list_users(_parent, _args, _resolution) do
    {:ok, Accounts.list_users()}
  end

  def register(_parent, args, _resolution) do
    Accounts.register_user(args)
  end

  def login(_parent, args, _resolution) do
    Accounts.login_user(args)
  end
end
