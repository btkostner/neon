defmodule NeonWeb.Accounts.UserSettingsController do
  use NeonWeb, :controller

  alias Neon.Accounts

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_flash(:success, "Email Changed", "Your account email address has been changed successfully.")
        |> redirect(to: Routes.user_settings_path(conn, :index))

      :error ->
        conn
        |> put_flash(:error, "Link Invalid", "Email change link is invalid or it has expired.")
        |> redirect(to: Routes.user_settings_path(conn, :index))
    end
  end
end
