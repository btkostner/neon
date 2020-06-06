defmodule NeonWeb.Schema do
  use Absinthe.Schema

  import_types NeonWeb.Schema.AccountTypes

  alias NeonWeb.Resolvers

  query do

    @desc "Get the current user's profile"
    field :profile, :user do
      resolve &Resolvers.Account.show_profile/3
    end

    @desc "Get all users"
    field :users, list_of(:user) do
      resolve &Resolvers.Account.list_users/3
    end

  end
end
