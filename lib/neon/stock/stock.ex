defmodule Neon.Stock do
  @moduledoc """
  The context related to anything stock market.
  """

  use Neon.Context

  import Ecto.Query
  import Neon.Query

  alias Neon.Service.Alpaca
  alias Neon.Stock.{Aggregate, Market, Symbol}

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_markets()
      [%Market{}, ...]

  """
  def list_markets do
    Repo.all(Market)
  end

  @doc """
  Gets a single market.

  ## Examples

      iex> get_market(123)
      %Market{}

      iex> get_market(456)
      nil

  """
  def get_market(id), do: Repo.get(Market, id)

  @doc """
  Creates a market.

  ## Examples

      iex> create_market(%{field: value})
      {:ok, %Market{}}

      iex> create_market(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_market(attrs \\ %{}) do
    %Market{}
    |> Market.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_market(market, %{field: new_value})
      {:ok, %Market{}}

      iex> update_market(market, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_market(%Market{} = market, attrs) do
    market
    |> Market.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a market.

  ## Examples

      iex> delete_market(market)
      {:ok, %Market{}}

      iex> delete_market(market)
      {:error, %Ecto.Changeset{}}

  """
  def delete_market(%Market{} = market) do
    Repo.delete(market)
  end

  @doc """
  Returns the list of symbols.

  ## Examples

      iex> list_symbols()
      [%Symbol{}, ...]

  """
  def list_symbols do
    Repo.all(Symbol)
  end

  @doc """
  Gets a single symbol.

  ## Examples

      iex> get_symbol(123)
      %Market{}

      iex> get_symbol(456)
      nil

  """
  def get_symbol(id), do: Repo.get(Symbol, id)

  @doc """
  Creates a symbol.

  ## Examples

      iex> create_symbol(%{field: value})
      {:ok, %Symbol{}}

      iex> create_symbol(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_symbol(attrs \\ %{}) do
    %Symbol{}
    |> Symbol.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a symbol.

  ## Examples

      iex> update_symbol(symbol, %{field: new_value})
      {:ok, %Symbol{}}

      iex> update_symbol(symbol, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_symbol(%Symbol{} = symbol, attrs) do
    symbol
    |> Symbol.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a symbol.

  ## Examples

      iex> delete_symbol(symbol)
      {:ok, %Symbol{}}

      iex> delete_symbol(symbol)
      {:error, %Ecto.Changeset{}}

  """
  def delete_symbol(%Symbol{} = symbol) do
    Repo.delete(symbol)
  end

  @doc """
  Returns the list of all aggregations.

  ## Examples

      iex> list_aggregates(%Symbol{})
      [%Aggregate{}, ...]

      iex> list_aggregates(%Symbol{}, width: "30 minutes")
      [%Aggregate{}, ...]

  """
  def list_aggregates(%{id: symbol_id}, opts \\ []) do
    width = Keyword.get(opts, :width, "5 minutes")
    limit = Keyword.get(opts, :limit, 100)

    Aggregate
    |> Aggregate.aggregate_query(interval(width))
    |> where([a], a.symbol_id == ^symbol_id)
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Returns the last stick in aggregate data. Used if someone wants to subscribe
  to more data, so we don't need to query _everything_ again.

  ## Examples

      iex> last_aggregate(%Symbol{})
      %Aggregate{}

      iex> last_aggregate(%Symbol{}, width: "30 minutes")
      %Aggregate{}

  """
  def last_aggregate(%{id: symbol_id}, opts \\ []) do
    width = Keyword.get(opts, :width, "5 minutes")

    Aggregate
    |> Aggregate.aggregate_query(interval(width))
    |> where([a], a.symbol_id == ^symbol_id)
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Creates a new stock aggregate. If the `inserted_at` date already exists for
  the symbol, we will update all other fields.

  ## Examples

      iex> create_aggregate(%{field: value})
      {:ok, %Aggregate{}}

      iex> create_aggregate(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_aggregate(attrs \\ %{}) do
    %Aggregate{}
    |> Aggregate.changeset(attrs)
    |> Repo.insert(on_conflict: :replace_all, conflict_target: [:symbol_id, :inserted_at])
    |> notify_change()
  end

  defp notify_change({:ok, %Aggregate{} = aggregate}) do
    Absinthe.Subscription.publish(NeonServer.Endpoint, aggregate, symbol_id: aggregate.symbol_id)
    {:ok, aggregate}
  end

  defp notify_change(res), do: res

  @doc """
  Inserts backfil aggregate data for a symbol. The second parameter is the
  exact `DateTime` to start, or the number of days from the current day. If
  neither is given, we backfill from the last known time.

  ## Examples

      iex> backfill_aggregate(%Symbol{})
      :ok

      iex> backfill_aggregate(%Symbol{}, 30)
      :ok

      iex> backfill_aggregate(%Symbol{}, DateTime.utc_now())
      :ok

  """
  def backfill_aggregate(%Aggregate{symbol_id: symbol_id, inserted_at: inserted_at}) do
    case get_symbol(symbol_id) do
      nil ->
        :not_found

      symbol ->
        start_at = DateTime.add(inserted_at, 60 * 5, :second)
        backfill_aggregate(symbol, start_at)
    end
  end

  def backfill_aggregate(%{symbol: symbol}, %DateTime{} = start) do
    {:ok, aggregated} = Alpaca.get_aggregated(symbol, start: start)
    backfill_aggregate_data(aggregated)
  end

  def backfill_aggregate(%{symbol: symbol}, days) do
    backfill_aggregate(symbol, Neon.Util.date_days_ago(days))
  end

  defp backfill_aggregate_data([]), do: :ok

  defp backfill_aggregate_data(aggregate) do
    aggregate
    |> Enum.map(&create_aggregate/1)
    |> Enum.map(fn {:ok, aggregate} -> aggregate end)
    |> Enum.sort(&(DateTime.compare(&1.inserted_at, &2.inserted_at) == :lt))
    |> Enum.at(-1)
    |> backfill_aggregate()
  end
end
