defmodule Neon.Util do
  @moduledoc """
  Some random utility functions used in the code.
  """

  @second_to_days 60 * 60 * 24

  @doc """
  Returns a `DateTime` that is `days` ago.
  """
  def date_days_ago(days) when is_binary(days) do
    days
    |> Integer.parse()
    |> elem(0)
    |> date_days_ago()
  end

  def date_days_ago(days) when is_integer(days) do
    DateTime.utc_now()
    |> DateTime.add(days * -1 * @second_to_days, :second)
  end

  def modulo_date(%{minute: minute} = datetime, position \\ :before, modulo \\ 5) do
    abs = floor(div(minute, modulo)) * modulo

    if position == :before do
      %{zeroed_seconds(datetime) | minute: abs}
    else
      DateTime.add(%{zeroed_seconds(datetime) | minute: abs}, modulo * 60, :second)
    end
  end

  defp zeroed_seconds(%{microsecond: microsecond} = datetime) do
    %{datetime | second: 0, microsecond: {0, elem(microsecond, 1)}}
  end
end
