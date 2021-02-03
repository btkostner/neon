defmodule NeonWeb.Router do
  use NeonWeb, :router

  import Phoenix.LiveDashboard.Router
  import NeonWeb.Authentication

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {NeonWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NeonWeb do
    pipe_through [:browser]

    get "/", HomepageController, :index
  end

  scope "/", NeonWeb do
    pipe_through [:browser, :user]

    live "/dashboard", DashboardLive, :index
  end

  scope "/admin", NeonWeb, as: :admin do
    pipe_through [:browser, :admin]

    live_dashboard "/dashboard",
      ecto_repos: [Neon.Repo],
      metrics: NeonWeb.Telemetry
  end

  scope "/", NeonWeb.Accounts do
    pipe_through [:browser, :guest]

    get "/register", UserRegistrationController, :new
    post "/register", UserRegistrationController, :create

    get "/log-in", UserSessionController, :new
    post "/log-in", UserSessionController, :create

    get "/log-in/two-factor", UserSessionController, :new_two_factor
    post "/log-in/two-factor", UserSessionController, :create_two_factor
    get "/log-in/backup-code", UserSessionController, :new_backup_codes
    post "/log-in/backup-code", UserSessionController, :create_backup_codes

    get "/reset-password", UserResetPasswordController, :new
    post "/reset-password", UserResetPasswordController, :create

    get "/reset-password/:token", UserResetPasswordController, :edit
    put "/reset-password/:token", UserResetPasswordController, :update
  end

  scope "/", NeonWeb.Accounts do
    pipe_through [:browser, :user]

    live "/users/settings", UserSettingsLive, :index
    get "/users/confirm-email/:token", UserSettingsController, :confirm_email
  end

  scope "/", NeonWeb.Accounts do
    pipe_through [:browser]

    delete "/log-out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end
