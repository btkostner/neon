defmodule NeonServer.Schemas.Account do
  use NeonServer, :schema

  alias Neon.Accounts
  alias NeonServer.Resolvers

  object :account_queries do
    @desc "Get the current user's profile"
    field :profile, :user, resolve: &Resolvers.Account.show_profile/3

    @desc "Get all users"
    field :users, list_of(:user), resolve: &Resolvers.Account.show_profile/3
  end

  object :account_mutations do
    @desc "Log in a user"
    field :login, type: :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolvers.Account.login/3
    end

    @desc "Creates a new user"
    field :register, type: :session do
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolvers.Account.register/3
    end
  end
end
