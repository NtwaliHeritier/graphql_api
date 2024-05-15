defmodule GraphqlApiWeb.Schema.Subscriptions.User do
  use Absinthe.Schema.Notation

  object :user_subscriptions do
    field :created_user, list_of(:user) do
      trigger(:create_user,
        topic: fn _ ->
          "new_user"
        end
      )

      config(fn _, _ ->
        {:ok, topic: "new_user"}
      end)
    end

    field :update_user_preference_subscription, :user_preference do
      arg :user_id, non_null(:integer)

      trigger(:update_user_preferences,
        topic: fn user ->
          "user_preference#{user.user_id}"
        end
      )

      config(fn user, _ ->
        {:ok, topic: "user_preference#{user.user_id}"}
      end)
    end

    field :update_resolver_counter, :integer do
      arg :key, non_null(:string)

      config(fn %{key: key}, _ ->
        {:ok, topic: "counter_changes_#{key}"}
      end)
    end
  end
end
