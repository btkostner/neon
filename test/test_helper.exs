{:ok, _} = Application.ensure_all_started(:bypass)
{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Payments.Repo, :manual)
