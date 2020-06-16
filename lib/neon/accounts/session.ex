defmodule Neon.Accounts.Session do
  @moduledoc """
  Tracks every single session instance for a user.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Neon.Accounts.User

  @session_expire_seconds 3600 * 24 * 2

  schema "sessions" do
    belongs_to :user, User, type: :binary_id

    field :ip, :string
    field :user_agent, :string

    timestamps(updated_at: false)
    field :expired_at, :utc_datetime
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:user_id, :ip, :user_agent, :inserted_at])
    |> put_expired_at()
    |> foreign_key_constraint(:user_id)
  end

  defp put_expired_at(changeset) do
    case get_field(changeset, :expired_at) do
      nil -> put_change(changeset, :expired_at, generate_expire_date())
      _ -> changeset
    end
  end

  defp generate_expire_date() do
    DateTime.utc_now()
    |> DateTime.add(@session_expire_seconds, :second)
    |> DateTime.truncate(:second)
  end

  def generate_token(session) do
    session.id
  end
end
