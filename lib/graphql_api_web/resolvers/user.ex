defmodule GraphqlApiWeb.Resolvers.User do
  alias GraphqlApi.{Accounts, ErrorUtils, MyCache}

  def find(params, _) do
    handle_user_requests("get_user")

    case Accounts.get_user(params) do
      {:ok, user} ->
        [{_key, token}] = MyCache.get(user.id)
        {:ok, Map.put(user, :auth_token, token)}

      # {:ok, user}

      {:error, _} ->
        {:error, ErrorUtils.not_found("User not found", params)}
    end
  end

  def all(params, _) do
    handle_user_requests("get_users")
    Accounts.all(params)
  end

  def create_user(params, _) do
    handle_user_requests("create_user")
    Accounts.create_user(params)
  end

  def update_user(%{id: id} = params, _) do
    handle_user_requests("update_user")
    Accounts.update_user(id, params)
  end

  def update_user_preferences(%{user_id: user_id} = params, _) do
    handle_user_requests("update_user_preferences")

    case Accounts.get_preference_by_user_id(%{user_id: user_id}) do
      {:ok, preference} -> Accounts.update_preference(preference.id, params)
      error -> error
    end
  end

  def get_hits(%{key: key}, _) do
    case MyCache.get(key) do
      [] -> {:ok, 0}
      [{_key, result}] -> {:ok, result}
    end
  end

  defp handle_user_requests(key) do
    MyCache.update_requests(key)
  end
end
