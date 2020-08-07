defmodule NeonServer.Types.Account do
  @moduledoc """
  GraphQL objects for the Neon.Account context.
  """

  use NeonServer, :schema

  alias Neon.Account

  object :account_session do
    field :user, :account_user

    field :token, :string do
      resolve(fn session, _data, _ ->
        {:ok, Phoenix.Token.sign(NeonServer.Endpoint, "session_id", session.id)}
      end)
    end

    field :ip, :string
    field :user_agent, :string

    field :expired_at, :datetime
  end

  object :account_user do
    field :id, :string

    field :name, :string
    field :email, :string

    field :avatar, :string do
      resolve(fn user, _, _ ->
        {:ok, Account.User.avatar(user)}
      end)
    end

    field :password, :string

    field :role, :string
  end
end
