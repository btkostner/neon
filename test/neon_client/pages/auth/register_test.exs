defmodule NeonWeb.Pages.Auth.RegisterTest do
  use ExUnit.Case
  use NeonClient.BrowserCase

  @name_input text_field("Full Name")
  @email_input text_field("Email Address")
  @password_input text_field("Password")
  @register_button button("Register")

  feature "client side input validation", %{session: session} do
    session =
      session
      |> visit("/auth/register")
      |> fill_in(@email_input, with: "testing")
      |> blur()

    assert text(session) =~ "email is not valid"
  end

  feature "allows registering an account", %{session: session} do
    session =
      session
      |> visit("/auth/register")
      |> fill_in(@name_input, with: "Blake")
      |> fill_in(@email_input, with: "blake@example.com")
      |> fill_in(@password_input, with: "thisisareallylongpassword")
      |> blur()
      |> click(@register_button)
      |> assert_has(link("Dashboard"))

    assert current_path(session) == "/"
  end
end
