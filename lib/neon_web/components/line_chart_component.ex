defmodule NeonWeb.AggregateChartComponent do
  use NeonWeb, :live_component

  import Ecto.Query

  alias Neon.Stocks

  @impl true
  def mount(socket) do
    {:ok, socket, temporary_assigns: [data: []]}
  end

  @impl true
  def update(assigns, socket) do
    symbol = Map.get(assigns, :symbol)

    aggregates =
      Stocks.Aggregate
      |> where(symbol: ^symbol)
      |> where([s], s.inserted_at >= ^Neon.Util.date_days_ago(30))
      |> Stocks.list_aggregates()

    {:ok, assign(socket, %{
      symbol: symbol,
      title: String.upcase(symbol),
      data: aggregates
    })}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div phx-hook="AggregateChart" class="chart">
      <h1><%= @title %></h1>

      <div class="chart-data" data-chart="<%= format_data(@data) %>">

      <div class="chart-body" phx-update="ignore" />
    </div>
    """
  end

  def format_data(aggregates) do
    aggregates
    |> Enum.map(&format_row/1)
    |> Enum.reverse()
    |> Jason.encode!()
  end

  def format_row(aggregate) do
    %{
      o: aggregate.open_price,
      h: aggregate.high_price,
      l: aggregate.low_price,
      c: aggregate.close_price,
      t: DateTime.to_unix(aggregate.inserted_at) * 1000
    }
  end
end
