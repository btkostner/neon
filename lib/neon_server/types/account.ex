defmodule NeonServer.Types.Account do
  @moduledoc """
  GraphQL objects for the Neon.Account context.
  """

  use NeonServer, :schema

  alias Neon.Accounts

  object :session do
    field :user, :user

    field :token, :string do
      resolve fn session, _, _ ->
        {:ok, Accounts.Session.generate_token(session)}
      end
    end

    field :ip, :string
    field :user_agent, :string

    field :expired_at, :datetime
  end

  object :user do
    field :id, :string

    field :name, :string
    field :email, :string

    field :gravatar_url, :string do
      resolve fn user, _, _ ->
        {:ok, Accounts.User.gravatar_url(user)}
      end
    end

    field :password, :string

    field :role, :string
  end
end
