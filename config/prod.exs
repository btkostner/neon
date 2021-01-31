import Config

config :neon, NeonWeb.Endpoint,
  url: [host: "neon.btkostner.io", port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info
