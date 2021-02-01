defmodule NeonWeb.Accounts.UserSettingsLive do
  use NeonWeb, :live_view

  alias Neon.Accounts

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)

    {:ok,
      socket
      |> assign(:user, user)
      |> assign(:email_changeset, Accounts.change_user_email(user))
      |> assign(:password_changeset, Accounts.change_user_password(user))
    }
  end

  @impl true
  def handle_event("update_email", %{"user" => %{"current_password" => password} = user_params}, socket) do
    case Accounts.apply_user_email(socket.assigns.user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_email_instructions(
          applied_user,
          socket.assigns.user.email,
          &Routes.user_settings_url(socket, :confirm_email, &1)
        )

        {:noreply,
          socket
          |> assign(:user, applied_user)
          |> assign(:email_changeset, Accounts.change_user_email(applied_user))
          |> put_flash(
            :info,
            "A link to confirm your email change has been sent to the new address."
          )
        }

      {:error, changeset} ->
        {:noreply, assign(socket, :email_changeset, changeset)}
    end
  end

  @impl true
  def handle_event("update_password", %{"user" => %{"current_password" => password} = user_params}, socket) do
    case Accounts.update_user_password(socket.assigns.user, password, user_params) do
      {:ok, user} ->
        {:noreply,
          socket
          |> put_flash(:info, "Password updated successfully.")
          |> redirect(to: Routes.user_settings_path(socket, :index))
        }

      {:error, changeset} ->
        {:noreply, assign(socket, :password_changeset, changeset)}
    end
  end

  def render(assigns) do
    NeonWeb.Accounts.UserSettingsView.render("index.html", assigns)
  end
end
