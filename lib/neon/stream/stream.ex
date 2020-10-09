defmodule Neon.Stream do
  @moduledoc """
  A supervisor tree for all of our live updating websocket connections to third
  party services.
  """

  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    children = [
      Neon.Stream.Alpaca,
      Neon.Stream.Polygon,
      Supervisor.child_spec({Cachex, name: Neon.Stream.AlpacaCache}, id: Neon.Stream.AlpacaCache),
      Supervisor.child_spec({Cachex, name: Neon.Stream.PolygonCache}, id: Neon.Stream.PolygonCache)
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.init(children, opts)
  end
end
