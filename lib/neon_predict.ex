defmodule NeonPredict do
  use Rustler,
    otp_app: :neon,
    crate: :neon_predict

  def predict(%{id: symbol_id}, length) do
    aggregates =
      Neon.Stock.list_aggregates(
        limit: 288,
        symbol_id: symbol_id,
        width: "5 minutes"
      )

    data = Enum.map(aggregates, &cast_aggregate/1)

    moving_averages(data, length)
  end

  defp cast_aggregate(aggregate) do
    %{
      open_price: Decimal.to_float(aggregate.open_price),
      high_price: Decimal.to_float(aggregate.high_price),
      low_price: Decimal.to_float(aggregate.low_price),
      close_price: Decimal.to_float(aggregate.close_price),
      volume: aggregate.volume,
      timestamp: NaiveDateTime.to_iso8601(aggregate.inserted_at, :extended)
    }
  end

  def moving_averages(_, _), do: :erlang.nif_error(:nif_not_loaded)
end
