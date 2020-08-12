defmodule Neon.Stock.Dataloader do
  @moduledoc """
  The dataloader schema queries. Used for advanced GraphQL Query resolving.
  """

  use Neon, :dataloader

  alias Neon.Stock

  def source() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(query, _), do: query
end
