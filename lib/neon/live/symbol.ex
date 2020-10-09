defmodule Neon.Live.Symbol do
  @moduledoc """
  A genserver for each `Neon.Stock.Symbol`. This does all the heavy lifting and
  processing for new stock data.
  """

  use GenServer

  require Logger

  alias Neon.{Stock, Util}
  alias Neon.Live.Inserter

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(symbol_id) do
    case Stock.get_symbol(id: symbol_id) do
      nil ->
        {:error, "No symbol for #{symbol_id}"}

      symbol ->
        {:ok,
         %{
           aggregates: [],
           current_timeframe: Util.modulo_date(DateTime.utc_now(), :before),
           symbol: symbol
         }}
    end
  end

  def handle_info(:new_timeframe, state) do
    {:noreply,
     %{state | aggregates: [], current_timeframe: Util.modulo_date(DateTime.utc_now(), :before)}}
  end

  def handle_cast({:push, aggregate}, state) do
    if Util.modulo_date(aggregate.inserted_at, :before) != state.current_timeframe do
      send(self(), :new_timeframe)
    end

    Inserter.push(aggregate)

    {:noreply, %{state | aggregates: [state.aggregates | aggregate]}}
  end

  def push(%{symbol_id: symbol_id} = aggregate) do
    {:ok, pid} = GenRegistry.lookup_or_start(__MODULE__, symbol_id, [symbol_id])
    GenServer.cast(pid, {:push, aggregate})
  end
end
