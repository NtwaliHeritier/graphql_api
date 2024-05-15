defmodule GraphqlApiWeb.Schema.Queries.User do
  use Absinthe.Schema.Notation
  alias GraphqlApiWeb.Resolvers

  object :user_queries do
    field :user, :user do
      arg(:id, non_null(:id))
      middleware(RequestCache.Middleware, ttl: :timer.seconds(60))
      resolve(&Resolvers.User.find/2)
    end

    field :users, list_of(:user) do
      arg(:likes_emails, :boolean)
      arg(:likes_phone_calls, :boolean)
      arg(:before, :integer)
      arg(:after, :integer)
      arg(:first, :integer)
      middleware(RequestCache.Middleware, ttl: :timer.seconds(60))
      resolve(&Resolvers.User.all/2)
    end

    field :resolver_hits, :integer do
      arg(:key, non_null(:string))
      middleware(RequestCache.Middleware, ttl: :timer.seconds(60))
      resolve(&Resolvers.User.get_hits/2)
    end
  end
end
