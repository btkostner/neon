defmodule Neon.Market do
  @moduledoc """
  A bunch of high level functions to deal with market data.
  """

  import Ecto.Query, warn: false

  alias Neon.Market.{Exchange, Ticker}
  alias Neon.Repo

  @doc """
  Returns a list of exchanges we know about.
  """
  def list_exchanges() do
    Repo.all(Exchange)
  end

  @doc """
  Returns a list of ordered results for tickers that match the text given.
  """
  def search_tickers(text, opts \\ []) do
    limit = Keyword.get(opts, :limit, 100)
    normalized_text = searchable_text(text)

    Ticker
    |> limit(^limit)
    |> ticker_search_query(normalized_text)
    |> Repo.all()
  end

  defp searchable_text(text) do
    text
  end

  defp ticker_search_query(query, ""), do: query

  defp ticker_search_query(query, text) do
    where(
      query,
      fragment(
        "to_tsvector('english', symbol || ' ' || name) @@ to_tsquery(?)",
        ^text
      )
    )
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
