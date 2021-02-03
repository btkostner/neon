defmodule NeonWeb.Accounts.UserSessionController do
  use NeonWeb, :controller

  alias Neon.Accounts
  alias NeonWeb.Authentication

  # The amount of time we will wait for a user's two factor code or backup code
  # before kicking them back to the login page.
  @two_factor_timeout 300

  plug :check_two_factor_data
       when action in [
              :new_two_factor,
              :new_backup_codes,
              :create_two_factor,
              :create_backup_codes
            ]

  def new(conn, _params) do
    conn
    |> reset_two_factor_data()
    |> assign(:page_title, "Log In")
    |> render("new.html", error_message: nil)
  end

  def new_two_factor(conn, _params) do
    conn
    |> assign(:page_title, "Log In")
    |> render("two_factor.html", error_message: nil)
  end

  def new_backup_codes(conn, _params) do
    conn
    |> assign(:page_title, "Log In")
    |> render("backup_codes.html", error_message: nil)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password} = user_params}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        render(conn, "new.html", error_message: "Invalid email or password")

      %{id: user_id, two_factor_seed: seed} when not is_nil(seed) ->
        basic_params = Map.drop(user_params, ["email", "password"])

        conn
        |> put_session(:session_two_factor_timestamp, DateTime.utc_now())
        |> put_session(:session_two_factor_user_id, user_id)
        |> put_session(:session_two_factor_params, basic_params)
        |> redirect(to: Routes.user_session_path(conn, :new_two_factor))

      user ->
        Authentication.log_in_user(conn, user, user_params)
    end
  end

  def create_two_factor(conn, %{"user" => %{"two_factor_code" => code} = user_params}) do
    user = conn.assigns.current_user

    if Accounts.valid_two_factor_code?(user, code) do
      Authentication.log_in_user(conn, user, get_session(conn, :session_two_factor_params))
    else
      render(conn, "two_factor.html", error_message: "Invalid two factor code")
    end
  end

  def create_backup_codes(conn, %{"user" => %{"backup_code" => code} = user_params}) do
    user = conn.assigns.current_user

    if Accounts.valid_backup_code?(user, code) do
      Authentication.log_in_user(conn, user, get_session(conn, :session_two_factor_params))
    else
      render(conn, "backup_codes.html", error_message: "Invalid backup code")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> Authentication.log_out_user()
  end

  defp reset_two_factor_data(conn) do
    conn
    |> delete_session(:session_two_factor_timestamp)
    |> delete_session(:session_two_factor_user_id)
    |> delete_session(:session_two_factor_params)
  end

  defp check_two_factor_data(conn, _opts) do
    login_datetime = get_session(conn, :session_two_factor_timestamp)
    user_id = get_session(conn, :session_two_factor_user_id)

    cond do
      is_nil(login_datetime) ->
        conn
        |> reset_two_factor_data()
        |> redirect(to: Routes.user_session_path(conn, :new))
        |> halt()

      DateTime.compare(
        DateTime.utc_now(),
        DateTime.add(login_datetime, @two_factor_timeout, :second)
      ) == :gt ->
        conn
        |> reset_two_factor_data()
        |> put_flash(:error, "You took too long to login. Please try again.")
        |> redirect(to: Routes.user_session_path(conn, :new))
        |> halt()

      true ->
        conn
        |> assign(:current_user, Accounts.get_user!(user_id))
    end
  end
end
