defmodule NeonWeb.DashboardLive.Index do
  use NeonWeb, :live_view

  @default_symbol "SNE"

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"symbol" => symbol}, _, socket) do
    {:noreply,
     socket
     |> assign(:symbol, String.upcase(symbol))
    }
  end

  @impl true
  def handle_params(%{}, _, socket) do
    {:noreply,
     socket
     |> assign(:symbol, @default_symbol)
    }
  end
end
