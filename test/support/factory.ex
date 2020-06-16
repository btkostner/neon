defmodule Neon.Factory do
  @moduledoc """
  This module uses ExMachina to generate fake database records used in testing.

  For more information, please
  [look at the docs](https://github.com/thoughtbot/ex_machina).
  """

  use ExMachina.Ecto, repo: Neon.Repo

  def user_factory(attrs) do
    password = Map.get(attrs, :password, "password")

    user = %Neon.Accounts.User{
      name: "John Wick",
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: password,
      password_hash: Argon2.hash_pwd_salt(password),
      role: :user
    }

    merge_attributes(user, attrs)
  end

  def session_factory do
    %Neon.Accounts.Session{
      user: build(:user),
      ip: "127.0.0.1",
      user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36",
      expired_at: ~U[2096-01-01 08:27:13Z]
    }
  end
end
