defmodule Neon.Dataloader do
  @moduledoc """
  Dataloader functions for Neon
  """

  @doc """
  Creates a new dataloader source with all of the available Neon contexts
  """
  def source() do
    Dataloader.new()
    |> Dataloader.add_source(Neon.Stock, Neon.Stock.Query.source())
  end
end
