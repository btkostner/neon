defmodule NeonWeb.DashboardLive.Index do
  use NeonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
