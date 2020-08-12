defmodule NeonServer do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use NeonServer, :controller
      use NeonServer, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: NeonServer

      import Plug.Conn
      import NeonServer.Gettext

      alias NeonServer.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/neon_server/templates",
        namespace: NeonServer

      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      import NeonServer.Gettext
    end
  end

  def resolver do
    quote do
      import Absinthe.Resolution.Helpers
    end
  end

  def schema do
    quote do
      use Absinthe.Schema.Notation

      import Absinthe.Resolution.Helpers

      alias NeonServer.Resolvers
    end
  end

  defp view_helpers do
    quote do
      use Phoenix.HTML

      import Phoenix.View
      import NeonServer.Gettext

      alias NeonServer.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
