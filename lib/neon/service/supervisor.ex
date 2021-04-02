defmodule Neon.Service.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    children = [
      {Finch, finch_config()}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp finch_config() do
    [
      name: Neon.Service.FinchService,
      pools: %{
        :default => [size: 10],
        "https://api.alpaca.markets" => [size: 10],
        "https://api.polygon.io" => [size: 10],
        "https://paper-api.alpaca.markets" => [size: 10]
      }
    ]
  end
end
