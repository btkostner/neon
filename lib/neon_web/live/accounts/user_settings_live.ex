defmodule NeonWeb.Accounts.UserSettingsLive do
  @moduledoc false

  use NeonWeb, :live_view

  alias Neon.Accounts

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        Accounts.get_user_by_session_token(user_token)
      end)

    {:ok,
     assign(socket,
       page_title: "Account Settings",
       profile_changeset: Accounts.change_user_profile(socket.assigns.current_user),
       email_changeset: Accounts.change_user_email(socket.assigns.current_user),
       password_changeset: Accounts.change_user_password(socket.assigns.current_user)
     )}
  end

  @impl true
  def handle_event(
        "update_profile",
        %{"user" => user_params},
        socket
      ) do
    case Accounts.update_user_profile(socket.assigns.current_user, user_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> assign(
           current_user: user,
           profile_changeset: Accounts.change_user_profile(user)
         )
         |> put_flash(
           :info,
           "Profile updated successfully."
         )}

      {:error, changeset} ->
        {:noreply, assign(socket, :profile_changeset, changeset)}
    end
  end

  @impl true
  def handle_event(
        "update_email",
        %{"user" => %{"current_password" => password} = user_params},
        socket
      ) do
    case Accounts.apply_user_email(socket.assigns.current_user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_email_instructions(
          applied_user,
          socket.assigns.current_user.email,
          &Routes.user_settings_url(socket, :confirm_email, &1)
        )

        {:noreply,
         socket
         |> assign(
           current_user: applied_user,
           email_changeset: Accounts.change_user_email(applied_user)
         )
         |> put_flash(
           :info,
           "A link to confirm your email change has been sent to the new address."
         )}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_changeset, changeset)}
    end
  end

  @impl true
  def handle_event(
        "update_password",
        %{"user" => %{"current_password" => password} = user_params},
        socket
      ) do
    case Accounts.update_user_password(socket.assigns.current_user, password, user_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password updated successfully.")
         |> redirect(to: Routes.user_settings_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, :password_changeset, changeset)}
    end
  end

  def render(assigns) do
    NeonWeb.Accounts.UserSettingsView.render("index.html", assigns)
  end
end
