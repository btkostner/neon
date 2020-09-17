defmodule NeonServer.Schemas.Account do
  @moduledoc """
  All GraphQL mutations and queries for the Neon.Account context.
  """

  use NeonServer, :schema

  object :account_queries do
    @desc "Get the current user's profile"
    field :account_profile, :account_user, resolve: &Resolvers.Account.show_profile/3

    @desc "Get all users"
    field :account_users, list_of(:account_user), resolve: &Resolvers.Account.list_users/3
  end

  object :account_mutations do
    @desc "Log in a user"
    field :account_login, type: :account_session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Account.login/3)
    end

    @desc "Creates a new user"
    field :account_register, type: :account_session do
      arg(:name, non_null(:string))
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Account.register/3)
    end
  end
end
