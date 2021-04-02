defmodule Neon.Market do
  @moduledoc """
  A bunch of high level functions to deal with market data.
  """

  alias Neon.Market.{Exchange, Ticker}
  alias Neon.Repo

  @doc """
  Returns a list of exchanges we know about.
  """
  def list_exchanges() do
    Repo.all(Exchange)
  end

  @doc """
  Creates a new ticker record.
  """
  def create_ticker(attrs) do
    %Ticker{}
    |> Ticker.changeset(attrs)
    |> Repo.insert(on_conflict: :nothing)
  end
end
