defmodule NeonServer.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom

  import_types NeonServer.Schemas.Account
  import_types NeonServer.Types.Account

  def context(ctx) do
    loader =
      Dataloader.new
      |> Dataloader.add_source(Neon.Repo, Dataloader.Ecto.new(Neon.Repo))

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: identifier})
  when identifier in [:query, :subscription, :mutation] do
    middleware ++ [NeonServer.Middleware.Errors]
  end
  def middleware(middleware, _field, _object) do
    middleware
  end

  query do
    import_fields :account_queries
  end

  mutation do
    import_fields :account_mutations
  end
end
