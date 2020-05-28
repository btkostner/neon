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
      NeonWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Neon.PubSub},
      # Start the Endpoint (http/https)
      NeonWeb.Endpoint,
      # Start a worker by calling: Neon.Worker.start_link(arg)
      # Neon.Importer
    ]

    Neon.Importer.start_link()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Neon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NeonWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
