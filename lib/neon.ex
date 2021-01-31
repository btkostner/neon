defmodule Neon do
  @moduledoc """
  The entrypoint for defining your data interface, such
  as schemas and so on.

  This can be used in your application as:

      use Neon, :schema

  The definitions below will be executed for every schema
  etc, so keep them short and clean, focused on imports,
  uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def schema do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import Ecto.Query

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id

      @timestamps_opts [type: :utc_datetime]
    end
  end

  @doc """
  When used, dispatch to the appropriate schema/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
