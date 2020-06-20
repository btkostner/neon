defmodule NeonServer.Router do
  use NeonServer, :router

  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html", "json", "stream"]
    plug :fetch_session
    plug :put_root_layout, {NeonServer.LayoutView, :root}

    if Mix.env() != :dev do
      plug :protect_from_forgery
    end

    plug :put_secure_browser_headers
  end

  scope "/" do
    pipe_through :browser

    live_dashboard "/debug", metrics: NeonServer.Telemetry

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: NeonServer.Schema,
      socket: NeonServer.UserSocket
  end

  scope "/", log: false do
    pipe_through :browser

    if Mix.env() == :dev do
      forward "/", ReverseProxyPlug, upstream: "http://localhost:3000"
    else
      forward "/", NeonServer.Plugs.Nuxt
    end
  end

  scope "/api" do
    forward "/", Absinthe.Plug, schema: NeonServer.Schema
  end
end
