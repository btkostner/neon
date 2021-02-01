import Config

config :neon, Neon.Repo,
  username: "postgres",
  password: "postgres",
  database: "neon_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("DATABASE_HOST", "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox

config :neon, NeonWeb.Endpoint,
  http: [port: 4002],
  server: true

config :logger, level: :warn

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8
