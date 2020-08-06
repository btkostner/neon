defmodule Mix.Tasks.Backfill do
  @moduledoc """
  Backfills any given symbol for X amount of days
  """

  use Mix.Task

  require Logger

  alias Neon.Repo
  alias Neon.Stocks

  @default_day_backfill 30

  def run(symbols) do
    start_services()

    symbols
    |> Enum.map(&parse_symbol/1)
    |> Enum.each(fn [symbol, days] ->
      Logger.info("Backfilling #{days} days for #{symbol}")
      Stocks.backfill_aggregate(symbol, days)
    end)
  end

  defp parse_symbol(input) do
    case String.split(input, ":") do
      [symbol] ->
        [symbol, @default_day_backfill]

      [symbol, days] ->
        {backfull, _} = Integer.parse(days)
        [symbol, backfull]

      _ ->
        Logger.error("Unable to parse \"#{input}\" for backfilling")
    end
  end

  defp start_services() do
    Mix.Task.run("app.start")
  end
end
