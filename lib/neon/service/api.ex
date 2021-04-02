defmodule Neon.Service.Api do
  @moduledoc """
  This module defines a standard set of functions for third party stock APIs.
  """

  @doc """
  Checks if the service is enabled and configured propertly.
  """
  @callback enabled?() :: Boolean.t()

  @doc """
  Grabs a list of all stock tickers available to the API.
  """
  @callback stock_tickers() :: {:ok, [Neon.Market.Ticker.t()]}
end
