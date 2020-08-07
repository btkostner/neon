defmodule NeonClient.BrowserCase do
  @moduledoc """
  This module defines the test case to be used by
  tests for neon_client.

  Such tests rely on `Wallaby` and also import other functionality
  to make it easier to query HTML documents and interact with them.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use NeonServer.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  import Wallaby.{Browser, Query}

  using do
    quote do
      use Wallaby.Feature

      import Plug.Conn
      import Neon.Factory

      import NeonClient.BrowserCase

      import Wallaby.Query,
        only: [
          css: 2,
          text_field: 1,
          button: 1,
          link: 1,
          link: 2
        ]
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Neon.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Neon.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Blurs the currently focused element on the page. Useful for testing form
  validation.
  """
  def blur(session) do
    execute_script(session, """
      if (document.activeElement != null && document.activeElement.blur != null) {
        document.activeElement.blur()
      }
    """)
  end

  @doc """
  A helper to log in under an account.
  """
  def login(session, user) do
    session
    |> visit("/auth/login")
    |> fill_in(text_field("Email Address"), with: user.email)
    |> fill_in(text_field("Password"), with: user.password)
    |> blur()
    |> click(button("Login"))
    |> assert_has(link("Dashboard"))
  end
end
