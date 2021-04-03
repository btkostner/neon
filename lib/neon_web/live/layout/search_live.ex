defmodule NeonWeb.Layout.SearchLive do
  @moduledoc false

  use Phoenix.LiveView,
    container: {:div, class: "flex min-w-0 flex-1"}

  alias Neon.Market

  @impl true
  def mount(_params, _assigns, socket) do
    {:ok, assign(socket, tickers: [], search: "")}
  end

  @impl true
  def handle_event("search", %{"search" => ""}, socket) do
    {:noreply, assign(socket, tickers: [], search: "")}
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    tickers = Market.search_tickers(search)
    {:noreply, assign(socket, tickers: tickers, search: search)}
  end

  @impl true
  def render(assigns) do
    NeonWeb.LayoutView.render("search.html", assigns)
  end
end
