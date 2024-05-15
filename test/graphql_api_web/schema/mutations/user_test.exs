defmodule GraphqlApiWeb.Schema.Mutations.UserTest do
  use GraphqlApiWeb.DataCase, async: true
  alias GraphqlApiWeb.Schema

  import GraphqlApiWeb.Support.User, only: [user_handle: 1]

  @create_user """
    mutation createUser($name: String!, $email: String!, $preference: UserInputPreferences!) {
      createUser(name: $name, email: $email, preference: $preference) {
        name
      }
    }
  """

  describe "@create_user" do
    test "adds user and returns list of all users" do
      {:ok, %{data: data}} =
        Absinthe.run(@create_user, Schema,
          variables: %{
            "name" => "Heritier",
            "email" => "heritierntwali@gmail.com",
            "preference" => %{"likesEmails" => true, "likesPhoneCalls" => true}
          }
        )

      assert length(data["createUser"]) == 1
      user = User |> first |> Repo.one()
      assert user.name == "Heritier"
    end
  end

  @update_user """
    mutation updateUser($id: ID!, $name: String, $email: String) {
      updateUser(id: $id, name: $name, email: $email) {
        name
        email
      }
    }
  """

  describe "@update_user" do
    setup [:user_handle]

    test "updates and returns an updated user", %{user: user} do
      {:ok, %{data: data}} =
        Absinthe.run(@update_user, Schema,
          variables: %{"id" => user.id, "name" => "Ntwali", "email" => "ntwali@gmail.com"}
        )

      assert data["updateUser"]["name"] == "Ntwali"
      assert data["updateUser"]["email"] == "ntwali@gmail.com"
    end
  end

  @update_user_preferences """
    mutation updateUserPreferences($userId: ID!, $likesEmails: Boolean!, $likesPhoneCalls: Boolean) {
      updateUserPreferences(userId: $userId, likesEmails: $likesEmails, likesPhoneCalls: $likesPhoneCalls) {
        likesEmails
        likesPhoneCalls
      }
    }
  """

  describe "@update_user_preferences" do
    setup [:user_handle]

    test "updates and returns user preferences", %{user: user} do
      {:ok, %{data: data}} =
        Absinthe.run(@update_user_preferences, Schema,
          variables: %{"userId" => user.id, "likesEmails" => false, "likesPhoneCalls" => false}
        )

      assert data["updateUserPreferences"]["likesEmails"] == false
      assert data["updateUserPreferences"]["likesPhoneCalls"] == false
    end
  end
end
