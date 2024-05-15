defmodule GraphqlApiWeb.Middleware.AuthMiddlewareTest do
  use ExUnit.Case
  alias GraphqlApiWeb.Middleware.AuthMiddleware

  describe("&call/2") do
    test "returns error when user not authenticated" do
      resolution = AuthMiddleware.call(%Absinthe.Resolution{}, nil)
      assert resolution.errors === ["Not authenticated"]
    end

    test "returns no error when user is authenticated" do
      resolution = AuthMiddleware.call(%Absinthe.Resolution{}, %{secret_key: "Imsecret"})
      assert resolution.errors === []
    end
  end
end
