defmodule NeonNotifier.Email do
  @moduledoc """
  Notifies user's about actions. Right now this just logs to the console, but in
  the future, it will send emails.
  """

  require Logger

  def deliver(to, body) do
    Logger.debug(body)

    {:ok, %{to: to, body: body}}
  end
end
