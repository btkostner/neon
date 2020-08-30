defmodule Neon.Stock do
  @moduledoc """
  The context related to anything stock market.
  """

  use Neon, :context

  import Neon.Query

  alias Neon.Service.Alpaca
  alias Neon.Stock.{Aggregate, Market, Query, Symbol}

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_markets()
      [%Market{}, ...]

      iex> list_markets(limit: 20)
      [%Market{}, ...]

  """
  def list_markets(params \\ []) do
    Market
    |> Query.query(params)
    |> Repo.all()
  end

  @doc """
  Gets a single market.

  ## Examples

      iex> get_market(id: 123)
      %Market{}

      iex> get_market(id: 456)
      nil

  """
  def get_market(params) do
    Market
    |> Query.query(params)
    |> Repo.one()
  end

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

      iex> list_symbols(limit: 20)
      [%Symbol{}, ...]

  """
  def list_symbols(params \\ []) do
    Symbol
    |> Query.query(params)
    |> Repo.all()
  end

  @doc """
  Gets a single symbol.

  ## Examples

      iex> get_symbol(id: 123)
      %Market{}

      iex> get_symbol(id: 456)
      nil

  """
  def get_symbol(params) do
    Symbol
    |> Query.query(params)
    |> Repo.one()
  end

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

      iex> list_aggregates(symbol_id: 123, limit: 300)
      [%Aggregate{}, ...]

      iex> list_aggregates(symbol_id: 123, width: "30 minutes")
      [%Aggregate{}, ...]

  """
  def list_aggregates(params \\ []) do
    Aggregate
    |> Query.query(params)
    |> Repo.all()
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
  def backfill_aggregate(%Aggregate{symbol_id: symbol_id} = aggregate) do
    case get_symbol(id: symbol_id) do
      nil -> :not_found
      symbol -> backfill_aggregate(symbol, aggregate)
    end
  end

  def backfill_aggregate(symbol, start, res \\ [])

  def backfill_aggregate(symbol, %Aggregate{inserted_at: inserted_at}, res) do
    start_at = DateTime.add(inserted_at, 60 * 5, :second)
    backfill_aggregate(symbol, start_at, res)
  end

  def backfill_aggregate(symbol, days, res) when is_integer(days) do
    backfill_aggregate(symbol, Neon.Util.date_days_ago(days), res)
  end

  def backfill_aggregate(symbol, %DateTime{} = start, res) do
    case DateTime.compare(start, DateTime.utc_now()) do
      :lt ->
        {:ok, data} = Alpaca.get_aggregated(symbol, start: start)

        aggregates =
          data
          |> Enum.map(&create_aggregate/1)
          |> Enum.map(fn {:ok, aggregate} -> aggregate end)
          |> Enum.sort(&(DateTime.compare(&1.inserted_at, &2.inserted_at) == :lt))

        new_start_at =
          aggregates
          |> Enum.at(-1, %{})
          |> Map.get(:inserted_at, DateTime.utc_now())
          |> DateTime.add(60 * 5, :second)

        backfill_aggregate(symbol, new_start_at, res ++ aggregates)

      _ ->
        {:ok, res}
    end
  end
end
