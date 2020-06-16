defmodule NeonServer.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: NeonServer.Schema

  @impl true
  def connect(%{"session" => session_id}, socket, _connect_info) do
    with {:ok, session} <- Accounts.get_session(session_id) do
      new_socket =
        socket
        |> assign(:session_id, session.id)
        |> assign(:user_id, session.user.id)
        |> assign(:user_role, session.user.role)

      {:ok, new_socket}
    end
  end

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  def id(%{assigns: %{session_id: session_id}} = socket),
    do: "session:" <> session_id

  def id(_socket), do: nil
end
