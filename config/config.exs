import Config

config :neon,
  ecto_repos: [Neon.Repo],
  generators: [binary_id: true]

config :neon, Neon.Repo, migration_timestamps: [type: :timestamptz]

config :neon, NeonWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GXiObwXi7SCzugRDGYYeA8SRfT1wdFcsP9bOgTdBNxQOnoQJOv2YnO1SlMgx1SxK",
  render_errors: [view: NeonWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Neon.PubSub,
  live_view: [signing_salt: "DzkCYlpB"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :neon, :services,
  alpaca: %{
    enabled: false,
    paper: false,
    api_key_id: "",
    api_secret_key: ""
  },
  polygon: %{
    enabled: false
  }

import_config "#{Mix.env()}.exs"

try do
  import_config "#{Mix.env()}.secret.exs"
rescue
  Code.LoadError -> :no_op
  File.Error -> :no_op
end
