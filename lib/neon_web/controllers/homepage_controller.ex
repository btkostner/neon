defmodule NeonWeb.HomepageController do
  use NeonWeb, :controller

  def index(conn, _params) do
    if conn.assigns[:current_user] do
      redirect(conn, to: Routes.dashboard_path(conn, :index))
    else
      redirect(conn, to: Routes.user_session_path(conn, :new))
    end
  end
end
