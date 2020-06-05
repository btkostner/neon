defmodule NeonWeb.Router do
  use NeonWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "stream"]
    plug :fetch_session

    if Mix.env() != :dev do
      plug :protect_from_forgery
    end

    plug :put_secure_browser_headers
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() == :dev do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/debug", metrics: NeonWeb.Telemetry
    end
  end

  scope "/" do
    pipe_through :browser

    if Mix.env() == :dev do
      forward "/", ReverseProxyPlug, upstream: "http://localhost:3000"
    else
      forward "/", NeonWeb.Plugs.Nuxt
    end
  end
end
