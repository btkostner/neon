defmodule Neon do
  @moduledoc """
  The entrypoint for defining neon contexts and files.

  This can be used in your application as:

      use Neon, :context
      use Neon, :schema

  The definitions below will be executed for every context,
  schema, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def context do
    quote do
      import Ecto.Query

      alias Ecto.Query
      alias Neon.Repo
    end
  end

  def query do
    quote do
      import Ecto.Query
      import Neon.Query

      alias Neon.Repo
    end
  end

  def schema do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import Ecto.Query
      import Neon.Query

      alias Neon.Repo

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
