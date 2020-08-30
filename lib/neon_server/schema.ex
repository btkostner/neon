defmodule NeonServer.Schema do
  @moduledoc """
  The root GraphQL schema for Absinthe and Neon.
  """

  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)

  import_types(NeonServer.Schemas.Account)
  import_types(NeonServer.Schemas.Stock)
  import_types(NeonServer.Types.Account)
  import_types(NeonServer.Types.Stock)

  def context(ctx) do
    ctx
    |> Map.put(:loader, Neon.Dataloader.source())
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
    import_fields(:account_queries)
    import_fields(:stock_queries)
  end

  mutation do
    import_fields(:account_mutations)
    import_fields(:stock_mutations)
  end

  subscription do
    import_fields(:stock_subscriptions)
  end
end
