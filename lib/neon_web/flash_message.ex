defmodule NeonWeb.FlashMessage do
  @moduledoc """
  Handles extending normal Phoenix flash message logic with these changes:

    - Add a title field to each message
    - Allow sending the same message multiple times (and show up multiple times)

  """

  @type type :: :info | :error | :success
  @type flash :: %{
    type: type,
    title: String.t(),
    message: String.t()
  }

  @doc """
  Adds a flash message. This is usable for regular conn connections, and socket
  live views.

  ## Examples

      iex> put_flash(conn, :error, "Title", "Notification message")
      # conn

      iex> put_flash(socket, :success, "Congraudlations", "Something went right!")
      # socket

  """
  def put_flash(%Plug.Conn{} = conn, type, title, message) do
    {key, flash} = native_flash(type, title, message)
    Phoenix.Controller.put_flash(conn, key, flash)
  end

  def put_flash(%Phoenix.LiveView.Socket{} = socket, type, title, message) do
    {key, flash} = native_flash(type, title, message)
    Phoenix.LiveView.put_flash(socket, key, flash)
  end

  defp native_flash(type, title, message) do
    {Ecto.UUID.generate(), %{
      type: type,
      title: title,
      message: message,
      timestamp: DateTime.utc_now() |> DateTime.to_unix()
    }}
  end

  @doc """
  Grabs all of the flash messages currently available. This will automatically sort
  them so they appear in the right order to the user.
  """
  def list_flash(%Plug.Conn{} = conn) do
    Enum.sort_by(conn.private.phoenix_flash, fn {_k, v} -> v.timestamp end)
  end

  def list_flash(%Phoenix.LiveView.Socket{} = socket) do
    Enum.sort_by(socket.assigns.flash, fn {_k, v} -> v.timestamp end)
  end

  def list_flash(flash) do
    Enum.sort_by(flash, fn {_k, v} -> v.timestamp end)
  end
end
