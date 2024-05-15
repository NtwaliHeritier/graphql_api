defmodule GraphqlApiWeb.Support.User do
  alias GraphqlApi.Accounts
  alias GraphqlApi.Accounts.User
  alias GraphqlApi.Repo

  import Ecto.Query

  def user_handle(_opts \\ []) do
    Accounts.create_user(%{
      name: "Heritier",
      email: "heritier@gmail.com",
      preference: %{likes_emails: true, likes_phone_calls: true}
    })

    user = User |> first |> Repo.one()
    %{user: user}
  end
end
