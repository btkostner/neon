defmodule NeonWeb.Accounts.UserConfirmationController do
  use NeonWeb, :controller

  alias Neon.Accounts

  def new(conn, _params) do
    conn
    |> assign(:page_title, "Confirm Email")
    |> render("new.html")
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &Routes.user_confirmation_url(conn, :confirm, &1)
      )
    end

    # Regardless of the outcome, show an impartial success/error message.
    conn
    |> put_flash(
      :info,
      "Email Confirmation",
      "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."
    )
    |> redirect(to: Routes.user_session_path(conn, :new))
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def confirm(conn, %{"token" => token}) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        conn
        |> put_flash(
          :sucess,
          "Account Confirmed",
          "Your account has been confirmed successfully."
        )
        |> redirect(to: Routes.user_session_path(conn, :new))

      :error ->
        # If there is a current user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the user themselves, so we redirect without
        # a warning message.
        case conn.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            redirect(conn, to: Routes.user_session_path(conn, :new))

          %{} ->
            conn
            |> put_flash(
              :error,
              "Link Invalid",
              "Your account confirmation link is invalid or it has expired."
            )
            |> redirect(to: Routes.user_session_path(conn, :new))
        end
    end
  end
end
