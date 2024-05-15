defmodule GraphqlApi.Accounts.Preference do
  use Ecto.Schema
  import Ecto.Changeset
  alias GraphqlApi.Accounts.User

  schema "preferences" do
    field :likes_emails, :boolean, default: false
    field :likes_phone_calls, :boolean, default: false
    belongs_to :user, User

    timestamps()
  end

  @validated_required [:likes_emails, :likes_phone_calls]
  @validated_attributes [:user_id | @validated_required]

  @doc false
  def changeset(preference, attrs) do
    preference
    |> cast(attrs, @validated_attributes)
    |> validate_required(@validated_required)
  end
end
