defmodule Neon.Stock.Query do
  @moduledoc """
  This module is used for Dataloader GraphQL reducing. It also holds all of the
  query reducers used for filtering and advanced queries by the context.
  """

  use Neon, :query

  alias Neon.Stock.{Aggregate, Market, Symbol}

  def source(),
    do: Dataloader.Ecto.new(Repo, query: &query/2)

  def query(source, args) when is_map(args),
    do: Enum.reduce(args, source, &(query(source, &2, &1)))

  def query(_source, query, {:id, id}) do
    from q in query,
      where: q.id == ^id
  end

  def query(Symbol, query, {:market_id, market_id}) do
    from q in query,
      join: m in assoc(q, :market),
      where: m.id == ^market_id
  end

  def query(Symbol, query, {:market_abbreviation, abbreviation}) do
    from q in query,
      join: m in assoc(q, :market),
      where: m.abbreviation == ^abbreviation
  end

  def query(Symbol, query, {:symbol, symbol}) do
    from q in query,
      where: q.symbol == ^String.upcase(symbol)
  end

  def query(Aggregate, query, {:width, width}) do
    from a in query,
      select: %Aggregate{
        open_price: max(a.open_price),
        high_price: max(a.high_price),
        low_price: min(a.low_price),
        close_price: min(a.low_price),
        volume: sum(a.volume),
        inserted_at: time_bucket(^interval(width), a.inserted_at)
      },
      group_by: :inserted_at,
      order_by: [desc: :inserted_at]
  end

  def query(_, query, {:limit, limit}) do
    from q in query,
      limit: ^limit
  end

  def query(_, query, _), do: query
  def query(query, _), do: query
end
