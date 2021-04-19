defmodule Neon.Time do
  @moduledoc """
  Some random utility functions dealing with `Time` and `DateTime`.
  """

  @doc """
  This will modulo a `DateTime` so it fits in an absolute time zone.

  ## Examples

      iex> Neon.Time.modulo_date(~U[2010-10-10 10:12:16Z], :before, 5)
      ~U[2010-10-10 10:10:00Z]

      iex> Neon.Time.modulo_date(~U[2010-10-10 10:12:16Z], :after, 10)
      ~U[2010-10-10 10:20:00Z]

  """
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
