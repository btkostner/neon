defmodule Neon.Stock.Query do
  @moduledoc """
  This module is used for Dataloader GraphQL reducing. It also holds all of the
  query reducers used for filtering and advanced queries by the context.
  """

  use Neon, :query

  alias Neon.Stock.{Aggregate, Market, Symbol}

  def source(),
    do: Dataloader.Ecto.new(Repo, query: &query/2)

  def query(source, args) when is_map(args) or is_list(args) do
    Enum.reduce(args, source, &query(source, &2, &1))
  end

  def query(_source, query, {:id, ids}) when is_list(ids) do
    from q in query,
      where: q.id in ^ids
  end

  def query(_source, query, {:id, id}) do
    from q in query,
      where: q.id == ^id
  end

  def query(_source, query, {:limit, limit}) do
    from q in query,
      limit: ^limit
  end

  def query(_source, query, {:offset, offset}) do
    from q in query,
      offset: ^offset
  end

  def query(Symbol, query, {:market_id, market_id}) do
    from q in query,
      join: m in assoc(q, :market),
      where: m.id == ^market_id
  end

  def query(Symbol, query, {:market_abbreviation, abbrs}) when is_list(abbrs) do
    upcase_abbrs = Enum.map(abbrs, &String.upcase/1)

    from q in query,
      join: m in assoc(q, :market),
      where: m.abbreviation in ^upcase_abbrs
  end

  def query(Symbol, query, {:market_abbreviation, abbr}) do
    from q in query,
      join: m in assoc(q, :market),
      where: m.abbreviation == ^String.upcase(abbr)
  end

  def query(Symbol, query, {:symbol, symbol}) do
    from q in query,
      where: q.symbol == ^String.upcase(symbol)
  end

  def query(Aggregate, query, {:symbol_id, symbol}) do
    from a in query,
      where: a.symbol_id == ^symbol
  end

  def query(Aggregate, query, {:width, width}) do
    from a in query,
      select: %Aggregate{
        id: fragment("last(?, inserted_at)::text", a.id),
        symbol_id: a.symbol_id,
        open_price: max(a.open_price),
        high_price: max(a.high_price),
        low_price: min(a.low_price),
        close_price: min(a.close_price),
        volume: max(a.volume),
        records: count(a.id),
        inserted_at: fragment("time_bucket(?, inserted_at) AS t", ^interval(width))
      },
      group_by: [fragment("t"), :symbol_id],
      order_by: fragment("t DESC")
  end

  def query(Aggregate, query, {:from, datetime}) do
    from a in query,
      where: a.inserted_at >= ^datetime
  end

  def query(Aggregate, query, {:to, datetime}) do
    from a in query,
      where: a.inserted_at <= ^datetime
  end

  def query(_, query, _), do: query
  def query(query, _), do: query
end
