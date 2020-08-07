defmodule Neon.Account.User do
  @moduledoc """
  Represents anyone who can log into the system.
  """

  use Neon.Schema

  @email_regex ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-\.]+\.[a-zA-Z]{2,}$/

  schema "account_users" do
    field :name, :string
    field :email, :string

    field :password, :string, virtual: true
    field :password_hash, :string

    field :role, Neon.Account.RoleEnum, default: :user

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :role])
    |> put_password_hash()
    |> validate_required([:name, :email, :password_hash, :role])
    |> validate_length(:name, max: 255)
    |> validate_length(:email, max: 255)
    |> validate_length(:password, min: 8)
    |> validate_format(:email, @email_regex)
    |> unique_constraint(:email)
  end

  defp put_password_hash(%{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset

  @doc """
  Returns a url to the user's avatar image.

  ## Examples

      iex> avatar(user)
      "https://www.gravatar.com/avatar/hashinformationhere"

  """
  def avatar(user) do
    hash =
      user.email
      |> String.trim()
      |> String.downcase()
      |> :erlang.md5()
      |> Base.encode16(case: :lower)

    "https://www.gravatar.com/avatar/#{hash}"
  end
end
