defmodule NeonWeb.DashboardLiveTest do
  use NeonWeb.ConnCase

  import Phoenix.LiveViewTest

  test "requires user to log in", %{conn: conn} do
    assert {:error,
            {:redirect,
             %{
               to: "/log-in"
             }}} = live(conn, Routes.dashboard_path(conn, :index))
  end
end
