defmodule NeonWeb.Accounts.UserRegistrationController do
  use NeonWeb, :controller

  alias Neon.Accounts
  alias Neon.Accounts.User
  alias NeonWeb.Authentication

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})

    conn
    |> assign(:page_title, "Register")
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(:success, "User Created", "Your user account has been created successfully.")
        |> Authentication.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:page_title, "Register")
        |> render("new.html", changeset: changeset)
    end
  end
end
