defmodule GraphqlApi.Accounts do
  alias GraphqlApi.Accounts.{User, Preference}
  alias EctoShorts.Actions

  def get_user(params) do
    Actions.find(User, params)
  end

  def all_user(params \\ %{}) do
    Actions.all(User, params)
  end

  def user_by_preference(query, params) do
    Actions.all(query, params)
  end

  def create_user(params) do
    Actions.create(User, params)
  end

  def update_user(id, params) do
    Actions.update(User, id, params)
  end

  def get_preference_by_user_id(params) do
    Actions.find(Preference, params)
  end

  def update_preference(id, params) do
    Actions.update(Preference, id, params)
  end

  def all(params) do
    case filter_by_preferences(params) do
      [] -> {:error, message: "Users not found", details: "No users found"}
      users -> {:ok, users}
    end
  end

  defp filter_by_preferences(preferences) when preferences === %{} do
    all_user()
  end

  defp filter_by_preferences(preferences) do
    {query, ecto_shorts_params} =
      Enum.reduce(preferences, {User.join_preference(), []}, &filter_by_preference/2)

    user_by_preference(query, ecto_shorts_params)
  end

  defp filter_by_preference({:likes_emails, value}, {query, ecto_shorts_params}) do
    {User.get_by_email(query, value), ecto_shorts_params}
  end

  defp filter_by_preference({:likes_phone_calls, value}, {query, ecto_shorts_params}) do
    {User.get_by_phone_calls(query, value), ecto_shorts_params}
  end

  defp filter_by_preference({key, val}, {query, ecto_shorts_params})
       when key in [:before, :after, :first] do
    {query, [{key, val} | ecto_shorts_params]}
  end
end
