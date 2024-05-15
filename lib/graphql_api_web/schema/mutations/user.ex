defmodule GraphqlApiWeb.Schema.Mutations.User do
  use Absinthe.Schema.Notation
  alias GraphqlApiWeb.Resolvers
  alias GraphqlApiWeb.Middleware.AuthMiddleware

  @secret "Imsecret"

  object :user_mutations do
    field :create_user, list_of(:user) do
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      arg :preference, non_null(:user_input_preferences)
      middleware(AuthMiddleware, %{secret_key: @secret})
      resolve &Resolvers.User.create_user/2
    end

    field :update_user, :user do
      arg :id, non_null(:id)
      arg :name, :string
      arg :email, :string
      middleware(AuthMiddleware, %{secret_key: @secret})
      resolve &Resolvers.User.update_user/2
    end

    field :update_user_preferences, :user_preference do
      arg :user_id, non_null(:id)
      arg :likes_emails, non_null(:boolean)
      arg :likes_phone_calls, :boolean
      middleware(AuthMiddleware, %{secret_key: @secret})
      resolve &Resolvers.User.update_user_preferences/2
    end
  end
end
