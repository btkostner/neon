defmodule NeonWeb.DashboardLive do
  @moduledoc false

  use NeonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Dashboard")}
  end

  @impl true
  def handle_params(_params, _session, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    NeonWeb.DashboardView.render("index.html", assigns)
  end
end
