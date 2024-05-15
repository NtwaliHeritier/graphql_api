defmodule GraphqlApiWeb.Types.User do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]
  alias GraphqlApi.Accounts

  input_object :user_input_preferences do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
  end

  object :user_preference do
    field :id, :id
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :user, :user, resolve: dataloader(Accounts, :user)
  end

  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
    field :auth_token, :string
    field :preferences, :user_preference, resolve: dataloader(Accounts, :preference)
  end
end
