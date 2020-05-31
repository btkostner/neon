# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :neon, Neon.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :neon, NeonWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

alpaca_key_id =
  System.get_env("ALPACA_KEY_ID") ||
    raise """
    environment variable ALPACA_KEY_ID is missing.
    You can generate one at https://app.alpaca.markets/
    """

alpaca_secret_key =
  System.get_env("ALPACA_SECRET_KEY") ||
    raise """
    environment variable ALPACA_SECRET_KEY is missing.
    You can generate one at https://app.alpaca.markets/
    """

config :neon, :alpaca,
  key_id: alpaca_key_id,
  secret_key: alpaca_secret_key
