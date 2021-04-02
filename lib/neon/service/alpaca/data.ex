defmodule Neon.Service.Alpaca.Data do
  @moduledoc """
  This handles all data transformation between the Alpaca API (and websocket)
  to internal Neon data structers.
  """

  def map_to_ticker(data) do
    %Neon.Market.Ticker{
      symbol: data["symbol"],
      name: data["name"],
      exchange_abbreviation: data["exchange"]
    }
  end
end
