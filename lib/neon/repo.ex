defmodule Neon.Repo do
  use Ecto.Repo,
    otp_app: :neon,
    adapter: Ecto.Adapters.Postgres
end
