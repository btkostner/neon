defmodule NeonServer.Plugs.Nuxt do
  @moduledoc """
  Redirects anything to the default nuxt static html page.
  """
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> put_resp_header("charset", "UTF-8")
    |> put_resp_content_type("text/html")
    |> send_file(200, "priv/static/index.html")
  end
end
