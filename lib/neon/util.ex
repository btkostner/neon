defmodule Neon.Util do
  @moduledoc """
  Some random utility functions used in the code.
  """

  @second_to_days 60 * 60 * 24

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
end
