defmodule Neon.Stream.Cache do
  @moduledoc """
  This is a read cache for stream data. It's used mostly for keeping a record of
  a service's foreign key to the internal Repo ID to avoid mass read queries
  when we get new socket updates.
  """

  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def clear(service) do
    GenServer.call(__MODULE__, {:clear, service})
  end

  def get(service, key) do
    GenServer.call(__MODULE__, {:read, service, key})
  end

  def set(service, values) do
    GenServer.cast(__MODULE__, {:set, service, values})
  end

  def set(service, key, value) do
    GenServer.cast(__MODULE__, {:set, service, key, value})
  end

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:clear, service}, _from, cache) do
    new_cache =
      Enum.filter(cache, fn {k, _v} ->
        not String.starts_with?(k, service)
      end)

    {:noreply, new_cache}
  end

  @impl true
  def handle_call({:read, service, key}, _from, cache) do
    {:reply, Map.get(cache, create_key(service, key)), cache}
  end

  @impl true
  def handle_cast({:set, service, values}, cache) do
    new_cache =
      Enum.reduce(values, cache, fn [k, v], c ->
        Map.put(c, create_key(service, k), v)
      end)

    {:noreply, new_cache}
  end

  @impl true
  def handle_cast({:set, service, key, value}, cache) do
    {:noreply, Map.put(cache, create_key(service, key), value)}
  end

  defp create_key(service, key) do
    to_string(service) <> "." <> key
  end
end
