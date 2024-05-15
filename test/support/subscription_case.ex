defmodule GraphqlApiWeb.SubscriptionCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use GraphqlApiWeb.ChannelCase
      use Absinthe.Phoenix.SubscriptionTest, schema: GraphqlApiWeb.Schema

      import Ecto.Query
      alias GraphqlApi.Repo
      alias GraphqlApi.Accounts
      alias GraphqlApi.Accounts.User

      setup do
        {:ok, socket} = Phoenix.ChannelTest.connect(GraphqlApiWeb.UserSocket, %{})
        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)
        {:ok, %{socket: socket}}
      end
    end
  end
end
