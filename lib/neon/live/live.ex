defmodule Neon.Live do
  @moduledoc """
  A supervisor tree for all of our live genservers and processing GenServers.
  """

  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    children = [
      Neon.Live.Inserter,
      {GenRegistry, worker_module: Neon.Live.Symbol}
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.init(children, opts)
  end
end
