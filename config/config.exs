# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :neon,
  ecto_repos: [Neon.Repo],
  generators: [binary_id: true]

config :neon, Neon.Repo, migration_timestamps: [type: :utc_datetime]

# Configures the endpoint
config :neon, NeonServer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "giHslHR3X1KcK1+DTbgio+LHo6CHbAwfY8PgGPU4fRbbPX+sCI0RQS0ajgS8JK4l",
  render_errors: [view: NeonServer.ErrorView, accepts: ~w(html json), layout: true],
  pubsub_server: Neon.PubSub,
  live_view: [signing_salt: "njdqhjV1"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tesla, adapter: Tesla.Adapter.Hackney

config :mime, :types, %{
  "text/event-stream" => ["stream"]
}

config :absinthe,
  schema: NeonServer.Schema

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
