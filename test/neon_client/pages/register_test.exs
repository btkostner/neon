defmodule NeonWeb.Pages.RegisterTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  import Wallaby.Query, only: [css: 2, text_field: 1, button: 1]

  @name_input text_field("Full Name")
  @email_input text_field("Email Address")
  @password_input text_field("Password")
  @register_button button("Register")

  feature "client side input validation", %{session: session} do
    session
    |> visit("/auth/register")
    |> fill_in(@email_input, with: "testing")
    |> focus_frame(@register_button)
    |> assert_has(Query.text("email is not valid"))
  end

  feature "allows registering an account", %{session: session} do
    session =
      session
      |> visit("/auth/register")
      |> fill_in(@name_input, with: "Blake")
      |> fill_in(@email_input, with: "blake@example.com")
      |> fill_in(@password_input, with: "thisisareallylongpassword")
      |> focus_frame(@register_button)
      |> click(@register_button)

    assert current_path(session) == "/"
  end
end
