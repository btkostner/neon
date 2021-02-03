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
       password_changeset: Accounts.change_user_password(socket.assigns.current_user),
       two_factor_changeset: Accounts.change_user_two_factor(socket.assigns.current_user),
       new_backup_codes: nil,
       new_two_factor_seed: nil
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

  @impl true
  def handle_event(
        "disable_two_factor",
        %{"user" => %{"current_password" => password}},
        socket
      ) do
    user_params = %{
      backup_codes: nil,
      two_factor_seed: nil
    }

    case Accounts.update_user_two_factor(socket.assigns.current_user, password, nil, user_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Two factor is now disabled.")
         |> reset_two_factor_fields(user)}

      {:error, changeset} ->
        {:noreply, assign(socket, :two_factor_changeset, changeset)}
    end
  end

  @impl true
  def handle_event(
        "enable_two_factor",
        %{"user" => %{"current_password" => password, "two_factor_code" => code}},
        socket
      ) do
    user_params = %{
      "backup_codes" => socket.assigns.new_backup_codes,
      "two_factor_seed" => socket.assigns.new_two_factor_seed
    }

    case Accounts.update_user_two_factor(socket.assigns.current_user, password, code, user_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Two factor is now enabled.")
         |> reset_two_factor_fields(user)}

      {:error, changeset} ->
        {:noreply, assign(socket, :two_factor_changeset, changeset)}
    end
  end

  @impl true
  def handle_event("enable_two_factor", _params, socket) do
    {:noreply,
     assign(socket,
       new_backup_codes: Accounts.generate_backup_codes(),
       new_two_factor_seed: Accounts.generate_two_factor_seed()
     )}
  end

  @impl true
  def render(assigns) do
    NeonWeb.Accounts.UserSettingsView.render("index.html", assigns)
  end

  defp reset_two_factor_fields(socket, user) do
    assign(socket,
      current_user: user,
      two_factor_changeset: Accounts.change_user_two_factor(user),
      new_backup_codes: nil,
      new_two_factor_seed: nil
    )
  end
end
