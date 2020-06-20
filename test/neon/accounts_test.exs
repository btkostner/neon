defmodule Neon.AccountsTest do
  use Neon.DataCase

  alias Neon.Accounts

  describe "users" do
    alias Neon.Accounts.User

    @update_attrs %{email: "testing@example.com"}
    @invalid_attrs %{email: ""}

    defp sanitize_user(user) do
      Map.put(user, :password, nil)
    end

    test "list_users/0 returns all users" do
      user = insert(:user)
      assert Accounts.list_users() == [sanitize_user(user)]
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      assert Accounts.get_user!(user.id) == sanitize_user(user)
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{}} = Accounts.create_user(params_for(:user))
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      assert {:ok, %User{} = user} = Accounts.update_user(insert(:user), @update_attrs)
      assert user.email == @update_attrs.email
    end

    test "update_user/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(insert(:user), @invalid_attrs)
    end
  end

  describe "sessions" do
    alias Neon.Accounts.Session

    test "get_session!/1 returns the session with given id" do
      session = insert(:session)
      assert Accounts.get_session!(session.id).id == session.id
    end

    test "get_session!/1 throws error with invalid id" do
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_session!(1) end
    end

    test "create_session/1 with valid data creates a session" do
      assert {:ok, %Session{}} = Accounts.create_session(params_with_assocs(:session))
    end
  end

  describe "user_login/1" do
    alias Neon.Accounts.Session

    test "with valid data creates a session" do
      user = insert(:user, password: "testing")
      assert {:ok, %Session{} = session} = Accounts.login_user(%{
        email: user.email,
        password: "testing",
        ip: "127.0.0.1",
        user_agent: "testing"
      })
      assert "127.0.0.1" = session.ip
      assert "testing" = session.user_agent
    end

    test "with invalid email returns :not_found" do
      assert {:error, :not_found} = Accounts.login_user(%{
        email: "no",
        password: "no"
      })
    end

    test "with invalid password returns :not_found" do
      user = insert(:user, password: "testing")
      assert {:error, :invalid_password} = Accounts.login_user(%{
        email: user.email,
        password: "this is not correct"
      })
    end
  end
end
