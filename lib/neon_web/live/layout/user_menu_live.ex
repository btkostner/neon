defmodule NeonWeb.Layout.UserMenuLive do
  use Phoenix.LiveView,
    container: {:div, class: "w-full"}

  alias Neon.Accounts

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)
    {:ok, assign(socket, :user, user)}
  end

  def render(assigns) do
    NeonWeb.LayoutView.render("user_menu.html", assigns)
  end
end
