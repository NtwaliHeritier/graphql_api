defmodule GraphqlApi.ErrorUtilsTest do
  use ExUnit.Case, async: true
  alias GraphqlApi.ErrorUtils

  describe "&not_found/2" do
    test "returns not_found error details" do
      params = %{id: 2}

      assert ErrorUtils.not_found("Not found", params) === %{
               code: :not_found,
               message: "Not found",
               details: params
             }
    end
  end

  describe "&conflict/2" do
    test "returns conflict error details" do
      params = %{email: "heritier@gmail.com"}

      assert ErrorUtils.conflict("Email already taken", params) === %{
               code: :conflict,
               message: "Email already taken",
               details: params
             }
    end
  end

  describe "&not_acceptable/2" do
    test "returns not_acceptable error details" do
      params = %{email: "2"}

      assert ErrorUtils.not_acceptable("Not acceptable", params) === %{
               code: :not_acceptable,
               message: "Not acceptable",
               details: params
             }
    end
  end

  describe "&internal_server_error/2" do
    test "returns internal_server error details" do
      params = %{email: "2"}

      assert ErrorUtils.internal_server_error("Internal server error", params) ===
               %{code: :internal_server_error, message: "Internal server error", details: params}
    end
  end
end
