defmodule Mix.Tasks.Neon.Service.ImportTickers do
  @moduledoc false
  @shortdoc "Import tickers from a third party service"

  use Mix.Task

  alias Neon.Market

  @impl Mix.Task
  def run([service]) do
    {:ok, _pid} = Application.ensure_all_started(:neon)

    with module when not is_nil(module) <- service_module(service),
         true <- apply(module, :enabled?, []),
         {:ok, tickers} <- apply(module, :stock_tickers, []) do
      {added_tickers, ticker_errors} =
        tickers
        |> Enum.map(&Map.from_struct/1)
        |> Enum.map(&Market.create_ticker/1)
        |> Enum.split_with(fn {res, _} -> res == :ok end)

      Mix.shell().info("Imported #{length(added_tickers)} tickers from #{service}")

      if length(ticker_errors) > 0 do
        Mix.shell().info("#{length(ticker_errors)} tickers errored while importing")
      end
    else
      nil ->
        Mix.shell().error("Module for #{service} is not defined")
        exit({:shutdown, 2})

      false ->
        Mix.shell().error("#{service} is not currently enabled. Please check configuration.")
        exit({:shutdown, 3})

      {:error, error} ->
        Mix.shell().error(inspect(error))
        exit({:shutdown, 1})
    end
  end

  def service_module(text) do
    Module.safe_concat([Neon, Service, text, Api])
  rescue
    ArgumentError -> nil
  end
end
