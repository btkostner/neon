defmodule NeonWeb.Pages.Auth.LoginTest do
  use ExUnit.Case
  use NeonClient.BrowserCase

  @email_input text_field("Email Address")
  @password_input text_field("Password")
  @login_button button("Login")

  feature "an invalid user does not allow login", %{session: session} do
    session =
      session
      |> visit("/auth/login")
      |> fill_in(@email_input, with: "noop@example.com")
      |> fill_in(@password_input, with: "password")
      |> blur()
      |> click(@login_button)

    assert current_path(session) == "/auth/login"
  end

  feature "allows login for a registered account", %{session: session} do
    user = insert(:account_user, password: "valid_password")

    session =
      session
      |> visit("/auth/login")
      |> fill_in(@email_input, with: user.email)
      |> fill_in(@password_input, with: "valid_password")
      |> blur()
      |> click(@login_button)
      |> assert_has(link("Dashboard"))

    assert current_path(session) == "/dashboard"
  end
end
