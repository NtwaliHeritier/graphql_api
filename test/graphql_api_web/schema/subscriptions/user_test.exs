defmodule GraphqlApiWeb.Schema.Subscriptions.UserTest do
  use GraphqlApiWeb.SubscriptionCase, async: true

  import GraphqlApiWeb.Support.User, only: [user_handle: 1]

  @create_user_subscription """
    subscription userCreateSub{
      createdUser{
        name
      }
    }
  """

  @create_user """
    mutation createUser($name: String!, $email: String!, $preference: UserInputPreferences!) {
      createUser(name: $name, email: $email, preference: $preference) {
        name
      }
    }
  """

  describe "@created_user" do
    test "updates socket on user create", %{socket: socket} do
      ref = push_doc(socket, @create_user_subscription)
      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ref =
        push_doc(socket, @create_user,
          variables: %{
            "name" => "Heritier",
            "email" => "heritierntwalin12@gmail.com",
            "preference" => %{"likesEmails" => true, "likesPhoneCalls" => true}
          }
        )

      assert_reply ref, :ok, reply
      assert %{data: %{"createUser" => [%{"name" => "Heritier"}]}} = reply
      assert_push "subscription:data", data

      assert %{
               subscriptionId: ^subscription_id,
               result: %{data: %{"createdUser" => [%{"name" => "Heritier"}]}}
             } = data
    end
  end

  @update_user_preference_sub """
    subscription userPreferenceSub($userId: Integer!) {
      updateUserPreferenceSubscription(userId: $userId) {
        likesEmails
      }
    }
  """

  @update_user_preferences """
    mutation updateUserPreferences($userId: ID!, $likesEmails: Boolean!, $likesPhoneCalls: Boolean) {
      updateUserPreferences(userId: $userId, likesEmails: $likesEmails, likesPhoneCalls: $likesPhoneCalls) {
        likesEmails
      }
    }
  """

  describe "@update_user_preference_subscription" do
    setup [:user_handle]

    test "updates socket on user preference update", %{socket: socket, user: user} do
      ref = push_doc(socket, @update_user_preference_sub, variables: %{"userId" => user.id})
      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ref =
        push_doc(socket, @update_user_preferences,
          variables: %{"userId" => user.id, "likesEmails" => false, "likesPhoneCalls" => false}
        )

      assert_reply ref, :ok, reply

      assert %{
               data: %{
                 "updateUserPreferences" => %{"likesEmails" => false}
               }
             } = reply

      assert_push "subscription:data", data

      assert %{
               result: %{
                 data: %{"updateUserPreferenceSubscription" => %{"likesEmails" => false}}
               },
               subscriptionId: ^subscription_id
             } = data
    end
  end
end
