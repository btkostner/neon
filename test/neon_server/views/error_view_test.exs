defmodule NeonServer.ErrorViewTest do
  use NeonServer.ConnCase, async: true

  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(NeonServer.ErrorView, "404.html", []) == "Not Found\n"
  end

  test "renders 500.html" do
    assert render_to_string(NeonServer.ErrorView, "500.html", []) == "Internal Server Error\n"
  end
end
