defmodule NeonWeb.Router do
  use NeonWeb, :router

  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html", "json", "stream"]
    plug :fetch_session
    plug :put_root_layout, {NeonWeb.LayoutView, :root}

    if Mix.env() != :dev do
      plug :protect_from_forgery
    end

    plug :put_secure_browser_headers
  end

  scope "/" do
    pipe_through :browser
    # TODO: Pipe through admin only authentication

    live_dashboard "/debug", metrics: NeonWeb.Telemetry

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: NeonWeb.Schema,
      socket: NeonWeb.UserSocket
  end

  scope "/" do
    pipe_through :browser

    if Mix.env() == :dev do
      forward "/", ReverseProxyPlug, upstream: "http://localhost:3000"
    else
      forward "/", NeonWeb.Plugs.Nuxt
    end
  end

  scope "/api" do
    forward "/", Absinthe.Plug, schema: NeonWeb.Schema
  end
end
