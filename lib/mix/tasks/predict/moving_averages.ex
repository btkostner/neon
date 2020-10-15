defmodule Mix.Tasks.Predict.MovingAverages do
  @moduledoc """
  Creates a list of moving averages for a stock.
  """

  use Mix.Task

  require Logger

  alias Neon.Stock

  def run([stock_symbol]) do
    run([stock_symbol, "5"])
  end

  @shortdoc "Creates a list of moving averages for a stock"
  def run([stock_symbol, length]) do
    start_services()

    symbol = Neon.Stock.get_symbol(symbol: stock_symbol)
    {length, _} = Integer.parse(length)

    results = NeonPredict.predict(symbol, length)

    IO.inspect(results, label: "results")
  end

  defp start_services(), do: Mix.Task.run("app.start")
end
