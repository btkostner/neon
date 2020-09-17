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
      Neon.Stream.Cache,
      Neon.Stream.Inserter,
      Neon.Stream.Alpaca
    ]

    opts = [strategy: :one_for_one, name: Neon.Stream.Supervisor]
    Supervisor.init(children, opts)
  end
end
