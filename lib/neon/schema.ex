defmodule Neon.Schema do
  @moduledoc """
  The default `Ecto.Schema` settings for Neon schemas. It also includes imports
  `Ecto.Query` and `Neon.Query`.
  """

  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import Ecto.Query
      import Neon.Query

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
