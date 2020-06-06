defmodule NeonWeb.Schema.AccountTypes do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :name, :string
    field :role, :string
    field :gravatar, :string
  end
end
