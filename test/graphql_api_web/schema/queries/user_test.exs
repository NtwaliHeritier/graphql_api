defmodule GraphqlApiWeb.Schema.Queries.UserTest do
  use GraphqlApiWeb.DataCase, async: true
  alias GraphqlApiWeb.Schema
  alias GraphqlApi.Accounts

  @all_users """
    query AllUsers($likesEmails: Boolean, $likesPhoneCalls: Boolean){
      users(likesEmails: $likesEmails, likesPhoneCalls: $likesPhoneCalls){
        name
      }
    }
  """
  describe "@users" do
    test "returns all users in the users table" do
      {:ok, _} = create_user()
      assert {:ok, %{data: data}} = Absinthe.run(@all_users, Schema)
      assert users = Accounts.all_user()
      assert length(data["users"]) == length(users)
    end

    test "returns users with preferences" do
      {:ok, _} = create_user()

      assert {:ok, %{data: data}} =
               Absinthe.run(@all_users, Schema,
                 variables: %{"likesEmails" => true, "likesPhoneCalls" => true}
               )

      {:ok, users} = Accounts.all(%{likes_emails: true, likes_phone_calls: true})
      assert length(data["users"]) == length(users)
    end
  end

  @user """
    query user($id: ID!) {
      user(id: $id) {
        name
      }
    }
  """

  describe "@user" do
    # test "returns user with specified id" do
    #   {:ok, user} = create_user()
    #   assert {:ok, %{data: data}} = Absinthe.run(@user, Schema, variables: %{"id" => user.id})
    #   assert {:ok, user} = Accounts.get_user(%{id: user.id})
    #   assert user.name == data["user"]["name"]
    # end

    test "returns no user found with specified id" do
      id = 50
      assert {:ok, %{data: data}} = Absinthe.run(@user, Schema, variables: %{"id" => id})
      assert data["user"] == nil
    end
  end

  # @resolvers_hits """
  #   query resolvehits($key: String!) {
  #     resolverHits(key: $key)
  #   }
  # """

  # describe "@resolver_hits" do
  #   test "return number of users query hits" do
  #     assert {:ok, _} = Absinthe.run(@all_users, Schema)
  #     assert {:ok, %{data: data}} = Absinthe.run(@resolvers_hits, Schema, variables: %{"key" => "get_users"})
  #     assert data["resolverHits"] == GraphqlApi.UserAgent.get_state("get_users")
  #   end

  #   test "return number of user query hits" do
  #     assert {:ok, _} = create_user()
  #     assert {:ok, _} = Absinthe.run(@user, Schema, variables: %{"id" => 13})
  #     assert {:ok, %{data: data}} = Absinthe.run(@resolvers_hits, Schema, variables: %{"key" => "get_user"})
  #     assert data["resolverHits"] == GraphqlApi.UserAgent.get_state("get_user")
  #   end
  # end

  defp create_user do
    Accounts.create_user(%{
      name: "Heritier",
      email: "heritiern@gmail.com",
      preference: %{likes_emails: true, likes_phone_calls: true}
    })
  end
end
