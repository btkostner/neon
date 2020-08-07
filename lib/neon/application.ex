defmodule Neon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Neon.Repo,
      # Start the Telemetry supervisor
      NeonServer.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Neon.PubSub},
      # Start the Endpoint (http/https)
      NeonServer.Endpoint,
      # Start Absinthe subscriptions
      {Absinthe.Subscription, NeonServer.Endpoint},
      # Start websocket intake streams
      Neon.Stream
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Neon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NeonServer.Endpoint.config_change(changed, removed)
    :ok
  end
end
