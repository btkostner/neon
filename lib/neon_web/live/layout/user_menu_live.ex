defmodule NeonWeb.Layout.UserMenuLive do
  @moduledoc false

  use Phoenix.LiveView,
    container: {:div, class: "w-full"}

  alias Neon.Accounts

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        Accounts.get_user_by_session_token(user_token)
      end)

    NeonWeb.Endpoint.subscribe("user:" <> socket.assigns.current_user.id)

    {:ok, socket}
  end

  @impl true
  def handle_info(%{event: "update", payload: user}, socket) do
    {:noreply, assign(socket, current_user: user)}
  end

  @impl true
  def handle_info(_event, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    NeonWeb.LayoutView.render("user_menu.html", assigns)
  end
end
