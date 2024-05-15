defmodule GraphqlApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias GraphqlApi.Accounts.{Preference, User}
  import Ecto.Query

  schema "users" do
    field :email, :string
    field :name, :string
    has_one :preference, Preference

    timestamps()
  end

  @validated_attributes [:name, :email]

  def create_changeset(params) do
    changeset(%User{}, params)
  end

  @doc false
  def changeset(user = %__MODULE__{}, attrs) do
    user
    |> cast(attrs, @validated_attributes)
    |> validate_required(@validated_attributes)
    |> cast_assoc(:preference)
    |> unique_constraint(:email)
  end

  def join_preference(query \\ User) do
    join(query, :inner, [u], p in assoc(u, :preference), as: :preference)
  end

  def get_by_email(query, likes_emails) do
    where(query, [preference: p], p.likes_emails == ^likes_emails)
  end

  def get_by_phone_calls(query, likes_phone_calls) do
    where(query, [preference: p], p.likes_phone_calls == ^likes_phone_calls)
  end
end
