defmodule Neon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start our HTTP client for third party services
      {Finch, finch_config()},
      # Start the Ecto repository
      Neon.Repo,
      # Start the Telemetry supervisor
      NeonWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Neon.PubSub},
      # Start the Endpoint (http/https)
      NeonWeb.Endpoint
      # Start a worker by calling: Neon.Worker.start_link(arg)
      # {Neon.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Neon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp finch_config() do
    [
      name: FinchService,
      pools: %{
        :default => [size: 10],
        "https://api.alpaca.markets" => [size: 10],
        "https://api.polygon.io" => [size: 10],
        "https://paper-api.alpaca.markets" => [size: 10]
      }
    ]
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NeonWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
