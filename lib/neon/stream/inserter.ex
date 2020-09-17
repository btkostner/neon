defmodule Neon.Stream.Inserter do
  @moduledoc """
  This is a debouncer to bulk insert data into the database from streams. It
  runs every 30 seconds and inserts all of the data it currently holds. This
  avoids expensive writes to the database every time there is new data, and
  replaces it with a single Ecto insert_all
  """

  use GenServer

  require Logger

  alias Neon.Stock

  @timeout 5 * 1000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def insert(data) do
    GenServer.cast(__MODULE__, {:insert, data})
    Process.send_after(__MODULE__, :insert, @timeout)
  end

  @impl true
  def init(_) do
    {:ok, []}
  end

  @impl true
  def terminate(_, datas) do
    insert_data(datas)
  end

  @impl true
  def handle_info(:insert, []) do
    {:noreply, []}
  end

  @impl true
  def handle_info(:insert, datas) do
    insert_data(datas)
    {:noreply, []}
  end

  @impl true
  def handle_cast({:insert, data}, datas) do
    {:noreply, [data | datas]}
  end

  defp insert_data(datas) do
    Logger.debug("Inserting #{length(datas)} aggregates into Repo")
    Stock.create_aggregates(datas)
  end
end
