import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :neon, Neon.Repo,
  username: "postgres",
  password: "postgres",
  database: "neon_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :neon, NeonServer.Endpoint,
  http: [port: 4002],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

config :wallaby,
  base_url: "http://localhost:4002",
  driver: Wallaby.Selenium,
  opt_app: :neon,
  screenshot_dir: Path.expand("#{__DIR__}/../test/neon_client_errors"),
  screenshot_on_failure: true,
  sql_sandbox: true

config :neon, :alpaca,
  key_id: "PKX3WI7D60LEIFZ5U4GI",
  secret_key: "B8DWKhN2qMF4hdkfaR07AxpZflxnT88e7lyI9IeG"
