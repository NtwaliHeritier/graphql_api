defmodule GraphqlApiWeb.Middleware.AuthMiddleware do
  @behaviour Absinthe.Middleware

  @impl Absinthe.Middleware
  def call(resolution, %{secret_key: "Imsecret"}) do
    resolution
  end

  def call(resolution, _) do
    Absinthe.Resolution.put_result(resolution, {:error, "Not authenticated"})
  end
end
