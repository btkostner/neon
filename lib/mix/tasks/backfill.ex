defmodule Mix.Tasks.Backfill do
  use Mix.Task

  require Logger

  alias Neon.Repo
  alias Neon.Stocks

  @default_day_backfill 30

  @start_apps [
    :hackney,
    :postgrex,
    :ecto,
    :ecto_sql
  ]

  def run([symbol]) do
    run([symbol, @default_day_backfill])
  end

  def run([symbol, days]) do
    start_services()

    Logger.info("Backfilling #{days} days for #{symbol}")
    Stocks.backfill_aggregate(symbol, days)
  end

  defp start_services() do
    Enum.each(@start_apps, &Application.ensure_all_started/1)
    Repo.start_link()
  end
end
