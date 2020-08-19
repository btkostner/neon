defmodule Neon.Account.Session do
  @moduledoc """
  Tracks every single session instance for a user.
  """

  use Neon, :schema

  alias Neon.Account.User

  @session_expire_seconds 3600 * 24 * 2

  schema "account_sessions" do
    field :ip, :string
    field :user_agent, :string

    field :expired, :boolean, default: false

    belongs_to :user, User

    timestamps(updated_at: false)
    field :expired_at, :utc_datetime
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:ip, :user_agent, :expired, :user_id, :inserted_at])
    |> validate_required([:expired, :user_id])
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

  @doc """
  Checks if the given session is valid for use or not

  ## Examples

      iex> valid_session?(valid_session)
      true

  """
  def valid?(%{expired: true}), do: false

  def valid?(session),
    do: DateTime.compare(DateTime.utc_now(), session.expired_at) == :lt
end
