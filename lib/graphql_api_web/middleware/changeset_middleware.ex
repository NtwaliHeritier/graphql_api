defmodule GraphqlApiWeb.Middleware.ChangesetMiddleware do
  @behaviour Absinthe.Middleware
  alias GraphqlApi.ErrorUtils

  @impl Absinthe.Middleware

  def call(%{value: nil, errors: [%{message: changeset_error}]} = resolution, _) do
    compute_error(changeset_error, resolution)
  end

  def call(%{value: nil, errors: [changeset_error]} = resolution, _) do
    compute_error(changeset_error, resolution)
  end

  def call(%{value: user} = resolution, _) do
    Absinthe.Resolution.put_result(resolution, {:ok, user})
  end

  def call(resolution, _) do
    resolution
  end

  def compute_error(changeset_error, resolution) do
    errors =
      changeset_error
      |> get_errors()
      |> Enum.reduce([], fn {field, errors}, acc ->
        for error <- errors do
          if error === "has already been taken" do
            [ErrorUtils.conflict("Conflict", %{field => error}) | acc]
          else
            [ErrorUtils.internal_server_error("Internal server error", %{field => error}) | acc]
          end
        end
      end)
      |> List.flatten()

    Absinthe.Resolution.put_result(resolution, {:error, errors})
  end

  defp get_errors(changeset_error) do
    Ecto.Changeset.traverse_errors(changeset_error, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
