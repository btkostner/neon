defmodule Neon.Stocks do
  @moduledoc """
  The context related to anything stock market.
  """

  import Ecto.Query
  import Neon.Query

  alias Neon.Repo
  alias Neon.Services.Alpaca
  alias Neon.Stocks.{Aggregate, Transaction}

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end

  @doc """
  Returns the list of all aggregations.

  ## Examples

      iex> list_aggregates("LYFT")
      [%Aggregate{}, ...]

      iex> list_aggregates("LYFT", width: "30 minutes")
      [%Aggregate{}, ...]

  """
  def list_aggregates(symbol, opts \\ []) do
    width = Keyword.get(opts, :width, "5 minutes")
    limit = Keyword.get(opts, :limit, 100)

    Aggregate
    |> Aggregate.aggregate_query(interval(width))
    |> where([a], a.symbol == ^symbol)
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Returns the last stick in aggregate data. Used if someone wants to subscribe
  to more data, so we don't need to query _everything_ again.

  ## Examples

      iex> last_aggregate("LYFT")
      %Aggregate{}

      iex> last_aggregate("LYFT", width: "30 minutes")
      %Aggregate{}

  """
  def last_aggregate(symbol, opts \\ []) do
    width = Keyword.get(opts, :width, "5 minutes")

    Aggregate
    |> Aggregate.aggregate_query(interval(width))
    |> where([a], a.symbol == ^symbol)
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
    |> Repo.insert(on_conflict: :replace_all, conflict_target: [:symbol, :inserted_at])
    |> notify_change()
  end

  defp notify_change({:ok, %Aggregate{} = aggregate}) do
    Absinthe.Subscription.publish(NeonServer.Endpoint, aggregate, aggregate: aggregate.symbol)
    {:ok, aggregate}
  end

  defp notify_change(res), do: res

  @doc """
  Inserts backfil aggregate data for a symbol. The second parameter is the
  exact `DateTime` to start, or the number of days from the current day. If
  neither is given, we backfill from the last known time.

  ## Examples

      iex> backfill_aggregate("LYFT")
      :ok

      iex> backfill_aggregate("LYFT", 30)
      :ok

      iex> backfill_aggregate("LYFE", DateTime.utc_now())
      :ok

  """
  def backfill_aggregate(%Aggregate{symbol: symbol, inserted_at: inserted_at}) do
    start_at = DateTime.add(inserted_at, 60 * 5, :second)
    backfill_aggregate(symbol, start_at)
  end

  def backfill_aggregate(symbol, %DateTime{} = start) do
    {:ok, aggregated} = Alpaca.get_aggregated(symbol, start: start)
    backfill_aggregate_data(aggregated)
  end

  def backfill_aggregate(symbol, days) do
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
