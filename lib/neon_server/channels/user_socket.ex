defmodule NeonServer.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: NeonServer.Schema

  alias Neon.Accounts

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case get_session(token) do
      {:ok, session} ->
        {:ok,
         socket
         |> assign(:session_id, session.id)
         |> assign(:user_role, session.user.role)}

      _ ->
        :error
    end
  end

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  def id(%{assigns: %{session_id: session_id}}),
    do: "session:" <> to_string(session_id)

  def id(_socket), do: nil

  defp get_session(token) do
    with {:ok, session_id} <- Phoenix.Token.verify(NeonServer.Endpoint, "session_id", token),
         session = Accounts.get_session!(session_id),
         true <- Accounts.valid_session?(session) do
      {:ok, session}
    end
  rescue
    _ -> :error
  end
end
