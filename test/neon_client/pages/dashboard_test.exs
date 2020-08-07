defmodule NeonWeb.Pages.DashboardTest do
  use ExUnit.Case
  use NeonClient.BrowserCase

  @settings_button Query.css(".avatar__subtitle")

  feature "admins have debug links in user menu", %{session: session} do
    user = insert(:account_user, role: :admin)

    session
    |> login(user)
    |> visit("/dashboard")
    |> click(@settings_button)
    |> assert_has(link("Debug System"))
    |> assert_has(link("Debug GraphQL"))
  end

  feature "users have a logout button in user menu", %{session: session} do
    user = insert(:account_user, role: :user)

    session
    |> login(user)
    |> visit("/dashboard")
    |> click(@settings_button)
    |> assert_has(link("Log Out"))
  end
end
