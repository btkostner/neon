defmodule NeonServer.Middleware.Errors do
  @moduledoc """
  Absinthe Middleware to translate errors and changeset errors into human
  readable messages.
  """

  @behaviour Absinthe.Middleware

  alias Ecto.Changeset

  def call(resolution, _) do
    %{resolution | errors: Enum.flat_map(resolution.errors, &handle_error/1)}
  end

  defp handle_error(%Changeset{} = changeset) do
    changeset
    |> Changeset.traverse_errors(&format_changeset_error/1)
    |> Enum.map(fn {k, v} -> "#{k} #{v}" end)
  end

  defp handle_error(error), do: [error]

  defp format_changeset_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
