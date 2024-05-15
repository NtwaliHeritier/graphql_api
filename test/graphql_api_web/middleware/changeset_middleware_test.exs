defmodule GraphqlApiWeb.Middleware.ChangesetMiddlewareTest do
  use GraphqlApiWeb.DataCase
  alias GraphqlApiWeb.Middleware.ChangesetMiddleware
  alias GraphqlApi.Accounts

  describe("&call/2") do
    test "returns changeset uniqueness error" do
      {:ok, _} =
        Accounts.create_user(%{
          name: "Heritier",
          email: "heritierntwa@gmail.com",
          preference: %{likes_emails: true, likes_phone_calls: true}
        })

      {:error, changeset_error} =
        Accounts.create_user(%{
          name: "Heritier",
          email: "heritierntwa@gmail.com",
          preference: %{likes_emails: true, likes_phone_calls: true}
        })

      resolution = %Absinthe.Resolution{
        errors: [changeset_error]
      }

      resolution = ChangesetMiddleware.call(resolution, nil)

      assert resolution.errors === [
               %{
                 code: :conflict,
                 details: %{email: "has already been taken"},
                 message: "Conflict"
               }
             ]
    end
  end
end
