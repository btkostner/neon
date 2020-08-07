defmodule Neon.AccountTest do
  use Neon.DataCase

  alias Neon.Account

  describe "user" do
    alias Neon.Account.User

    @update_attrs %{email: "testing@example.com"}
    @invalid_attrs %{email: ""}

    defp sanitize_user(user) do
      Map.put(user, :password, nil)
    end

    test "list_users/0 returns all users" do
      user = insert(:account_user)
      assert Account.list_users() == [sanitize_user(user)]
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:account_user)
      assert Account.get_user!(user.id) == sanitize_user(user)
    end

    test "get_user_by_email!/1 returns the user with given email" do
      user = insert(:account_user)
      assert Account.get_user_by_email!(user.email) == sanitize_user(user)
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{}} = Account.create_user(params_for(:account_user))
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      assert {:ok, %User{} = user} = Account.update_user(insert(:account_user), @update_attrs)
      assert user.email == @update_attrs.email
    end

    test "update_user/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Account.update_user(insert(:account_user), @invalid_attrs)
    end

    test "delete_user!/1 deletes a user" do
      user = insert(:account_user)
      assert Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end
  end

  describe "session" do
    alias Neon.Account.Session

    test "get_session!/1 returns the session with given id" do
      session = insert(:account_session)
      assert Account.get_session!(session.id).id == session.id
    end

    test "get_session!/1 throws error with invalid id" do
      assert_raise Ecto.NoResultsError, fn -> Account.get_session!(Ecto.UUID.generate()) end
    end

    test "create_session/1 with valid data creates a session" do
      assert {:ok, %Session{}} = Account.create_session(params_with_assocs(:account_session))
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_session(params_for(:account_session))
    end
  end

  describe "auth" do
    alias Neon.Account.Session

    test "login_user/1 with valid data creates a session" do
      user = insert(:account_user, password: "testing")

      assert {:ok, %Session{}} =
               Account.login_user(%{
                 email: user.email,
                 password: "testing",
                 ip: "127.0.0.1",
                 user_agent: "testing"
               })
    end

    test "login_user/1 with invalid email returns :not_found" do
      assert {:error, :not_found} =
               Account.login_user(%{
                 email: "no",
                 password: "no"
               })
    end

    test "login_user/1 with invalid password returns :invalid_password" do
      user = insert(:account_user, password: "testing")

      assert {:error, :invalid_password} =
               Account.login_user(%{
                 email: user.email,
                 password: "this is not correct"
               })
    end

    test "register_user/1 with valid data creates a session" do
      user = params_for(:account_user)

      assert {:ok, %Session{}} =
               Account.register_user(
                 Map.merge(user, %{
                   ip: "127.0.0.1",
                   user_agent: "testing"
                 })
               )
    end

    test "register_user/1 with invalid params returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.register_user(%{})
    end
  end
end
