defmodule Neon.Service.Alpaca.Api do
  @moduledoc """
  API module for https://alpaca.markets/
  """

  use Tesla

  alias Neon.Service.Alpaca.Data

  @behavior Neon.Service.Api

  adapter(Tesla.Adapter.Finch, name: FinchService)

  if Application.get_env(:neon, :services)[:alpaca].paper do
    plug Tesla.Middleware.BaseUrl, "https://paper-api.alpaca.markets"
  else
    plug Tesla.Middleware.BaseUrl, "https://api.alpaca.markets"
  end

  plug Tesla.Middleware.Headers, [
    {"APCA-API-KEY-ID", Application.get_env(:neon, :services)[:alpaca].api_key_id},
    {"APCA-API-SECRET-KEY", Application.get_env(:neon, :services)[:alpaca].api_secret_key}
  ]

  plug Tesla.Middleware.FollowRedirects
  plug Tesla.Middleware.Logger
  plug Tesla.Middleware.PathParams
  plug Tesla.Middleware.JSON

  @impl true
  def enabled?() do
    config = Application.get_env(:neon, :services)[:alpaca]
    config.enabled and config.api_key_id != "" and config.api_secret_key != ""
  end

  @impl true
  def stock_tickers() do
    with {:ok, res} <- get("/v2/assets", query: [status: "active", tradable: true]) do
      Enum.map(res.body, &Data.map_to_ticker/1)
    end
  end
end
