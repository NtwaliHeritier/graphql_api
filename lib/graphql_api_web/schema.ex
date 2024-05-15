defmodule GraphqlApiWeb.Schema do
  use Absinthe.Schema

  import_types GraphqlApiWeb.Types.User
  import_types GraphqlApiWeb.Schema.Queries.User
  import_types GraphqlApiWeb.Schema.Mutations.User
  import_types GraphqlApiWeb.Schema.Subscriptions.User

  alias GraphqlApi.{Repo, Accounts}
  alias GraphqlApiWeb.Middleware.ChangesetMiddleware

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
  end

  subscription do
    import_fields :user_subscriptions
  end

  def context(ctx) do
    source = Dataloader.Ecto.new(Repo)
    loader = Dataloader.add_source(Dataloader.new(), Accounts, source)
    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  def middleware(middleware, _, %{identifier: identifier}) when identifier === :mutation do
    middleware ++ [ChangesetMiddleware]
  end

  def middleware(middleware, _, _) do
    middleware
  end
end
