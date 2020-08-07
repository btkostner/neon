defmodule NeonServer.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: NeonServer.Schema

  alias Neon.Account

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case get_session(token) do
      {:ok, session} ->
        updated_socket =
          socket
          |> assign(:session_id, session.id)
          |> assign(:user_role, session.user.role)
          |> Absinthe.Phoenix.Socket.put_options(
            context: %{
              session_id: session.id,
              user_role: session.user.role
            }
          )

        {:ok, updated_socket}

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
         session = Account.get_session!(session_id),
         true <- Account.Session.valid?(session) do
      {:ok, session}
    end
  rescue
    _ -> :error
  end
end
