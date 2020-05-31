defmodule NeonWeb.LineChartComponent do
  use NeonWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket, temporary_assigns: [data: []]}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, %{
      id: 1,
      title: "Graph Data",
      data: [
        %{date: DateTime.utc_now(), value: 1000}
      ]
    })}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="chart" id="chart-<%= @id %>">
      <h1><%= @title %></h1>

      <div class="chart-body">
        <div phx-hook="LineChartComponent" id="chart-<%= @id %>--datasets" style="display:none;">
        <%= for d <- @data do %>
          <span data-x="<%= x_value(d) %>" data-y="<%= y_value(d) %>" />
        <% end %>
        </div>

        <div class="chart"
            id="chart-ignore-<%= @id %>"
            phx-update="ignore"
        </div>
      </div>
    </div>
    """
  end

  defp x_value(data), do: data.date

  defp y_value(data), do: data.value
end
