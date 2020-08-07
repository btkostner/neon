defmodule Neon.Query do
  @moduledoc """
  A module that builds on `Ecto.Query` to include timescale db specific macros.
  Wrapped up for convenience and security.
  """

  @doc """
  Timescale db's `time_bucket` SQL function with some security addons.
  """
  defmacro time_bucket(width, field) do
    quote do
      fragment("time_bucket(?, ?)", unquote(width), unquote(field))
    end
  end

  @doc """
  Converts a time string into a `Postgrex.Interval`.

  ## Examples

      iex> interval("5 minutes")
      %Postgex.Interval{secs: 300}

      iex> interval("20 hours")
      %Postgex.Interval{secs: 72000}

  """
  def interval(interval) do
    {time, remainder} = Integer.parse(interval)

    cond do
      String.ends_with?(remainder, "seconds") ->
        %Postgrex.Interval{secs: time}

      String.ends_with?(remainder, "minutes") ->
        %Postgrex.Interval{secs: time * 60}

      String.ends_with?(remainder, "hours") ->
        %Postgrex.Interval{secs: time * 60 * 60}

      String.ends_with?(remainder, "days") ->
        %Postgrex.Interval{days: time}

      String.ends_with?(remainder, "months") ->
        %Postgrex.Interval{months: time}

      String.ends_with?(remainder, "years") ->
        %Postgrex.Interval{months: time * 12}
    end
  end
end
