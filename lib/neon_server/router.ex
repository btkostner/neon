defmodule NeonServer.Router do
  use NeonServer, :router

  pipeline :browser do
    plug Plug.Telemetry, event_prefix: [:plug]

    plug :accepts, ["html", "json", "stream"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {NeonServer.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug Plug.Telemetry, event_prefix: [:plug]

    plug :accepts, ["html", "json", "stream"]
    plug :fetch_session
    plug :put_secure_browser_headers
  end

  pipeline :auth do

  end

  scope "/system", as: :system do
    pipe_through [:browser, :auth]

    live_dashboard "/debug",
      metrics: NeonServer.Telemetry

    forward "/graphql", Absinthe.Plug.GraphiQL,
      default_url: "/graphql",
      socket_url: "/graphql",
      schema: NeonServer.Schema,
      socket: NeonServer.UserSocket,
      interface: :advanced
  end

  scope "/", as: :frontend, log: false do
    pipe_through :api

    forward "/graphql", Absinthe.Plug,
      schema: NeonServer.Schema

    if Mix.env() == :dev do
      forward "/", ReverseProxyPlug, upstream: "http://localhost:3000"
    else
      forward "/", NeonServer.Plugs.Nuxt
    end
  end
end
