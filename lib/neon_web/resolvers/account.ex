defmodule NeonWeb.Resolvers.Account do
  def show_profile(_parent, _args, _resolution) do
    {:ok, %{
      name: "Blake Kostner",
      role: :admin,
      gravatar: "https://s.gravatar.com/avatar/38f0782764cf3df788a194494de08510"
    }}
  end

  def list_users(_parent, _args, _resolution) do
    {:ok, []}
  end
end
