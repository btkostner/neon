defmodule Neon.Context do
  @moduledoc """
  A simple top level context helper module. Aliases `Neon.Repo` and
  `Ecto.Query`.
  """

  defmacro __using__(_) do
    quote do
      import Ecto.Query

      alias Ecto.Query
      alias Neon.Repo
    end
  end
end
