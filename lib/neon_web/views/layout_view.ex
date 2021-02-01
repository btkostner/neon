defmodule NeonWeb.LayoutView do
  use NeonWeb, :view

  def update_available?(socket) do
    Phoenix.LiveView.static_changed?(socket)
  end
end
