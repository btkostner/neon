defmodule NeonWeb.Accounts.UserSettingsLiveTest do
  use NeonWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Neon.AccountsFixtures

  alias Neon.Accounts

  setup :register_and_log_in_user

  describe "GET /users/settings" do
    test "renders settings page", %{conn: conn} do
      {:ok, view, html} = live(conn, Routes.user_settings_path(conn, :index))
      assert html =~ "Settings"
      assert render(view) =~ "Settings"
    end

    test "redirects if user is not logged in" do
      conn = build_conn()
      conn = get(conn, Routes.user_settings_path(conn, :index))
      assert redirected_to(conn) == Routes.user_session_path(conn, :new)
    end
  end

  describe "PUT /users/settings (change password form)" do
    test "updates the user password and resets tokens", %{conn: conn, user: user} do
      {:ok, view, _html} = live(conn, Routes.user_settings_path(conn, :index))

      data = %{
        "user" => %{
          "current_password" => valid_user_password(),
          "password" => "New valid p@ssword",
          "password_confirmation" => "New valid p@ssword"
        }
      }

      assert {:error, {:redirect, %{to: "/users/settings"}}} =
               view
               |> form("#update-password-form", data)
               |> render_submit()

      assert Accounts.get_user_by_email_and_password(user.email, "New valid p@ssword")
    end

    test "does not update password on invalid data", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.user_settings_path(conn, :index))

      data = %{
        "user" => %{
          "current_password" => valid_user_password(),
          "password" => "too short",
          "password_confirmation" => "does not match"
        }
      }

      html =
        view
        |> form("#update-password-form", data)
        |> render_submit()

      assert html =~ "Settings"
      assert html =~ "should be at least 12 character(s)"
      assert html =~ "does not match password"
    end
  end

  describe "PUT /users/settings (change email form)" do
    @tag :capture_log
    test "updates the user email", %{conn: conn, user: user} do
      {:ok, view, _html} = live(conn, Routes.user_settings_path(conn, :index))

      data = %{
        "user" => %{
          "current_password" => valid_user_password(),
          "email" => unique_user_email()
        }
      }

      html =
        view
        |> form("#update-email-form", data)
        |> render_submit()

      assert html =~ "A link to confirm your email"
      assert Accounts.get_user_by_email(user.email)
    end

    test "does not update email on invalid data", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.user_settings_path(conn, :index))

      data = %{
        "user" => %{
          "current_password" => valid_user_password(),
          "email" => "with spaces"
        }
      }

      html =
        view
        |> form("#update-email-form", data)
        |> render_submit()

      assert html =~ "Settings"
      assert html =~ "must have the @ sign and no spaces"
    end
  end
end
