defmodule Neon.Live.Inserter do
  @moduledoc """
  This is a debouncer to bulk insert data into the database from streams. It
  runs every 30 seconds and inserts all of the data it currently holds. This
  avoids expensive writes to the database every time there is new data, and
  replaces it with a single Ecto insert_all
  """

  use GenServer

  require Logger

  alias Neon.Stock

  @timeout 10 * 1000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_) do
    Process.send_after(self(), :insert, @timeout)
    {:ok, %{aggregates: []}}
  end

  @impl true
  def terminate(_, %{aggregates: aggregates}) do
    insert_aggregates(aggregates)
  end

  @impl true
  def handle_info(:insert, %{aggregates: aggregates} = state) do
    Process.send_after(self(), :insert, @timeout)

    insert_aggregates(aggregates)
    {:noreply, %{state | aggregates: []}}
  end

  @impl true
  def handle_cast({:push, aggregate}, state) do
    {:noreply, %{state | aggregates: [aggregate | state.aggregates]}}
  end

  defp insert_aggregates([]), do: :ok

  defp insert_aggregates(aggregates) do
    deduped_aggregates = Enum.uniq_by(aggregates, & &1.symbol_id)

    Logger.debug("Inserting #{length(deduped_aggregates)} aggregates into Repo")
    Stock.create_aggregates(deduped_aggregates)
  end

  @doc """
  Pushes a new aggregate record to be debounce inserted into the database.
  """
  def push(aggregate) do
    GenServer.cast(__MODULE__, {:push, aggregate})
  end
end
