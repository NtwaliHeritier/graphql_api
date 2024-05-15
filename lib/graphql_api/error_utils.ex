defmodule GraphqlApi.ErrorUtils do
  @error_types [:not_found, :internal_server_error, :not_acceptable, :conflict]

  Enum.each(@error_types, fn name ->
    def unquote(name)(message, details) do
      create_error(unquote(name), message, details)
    end
  end)

  defp create_error(code, message, details) do
    %{message: message, details: details, code: code}
  end
end
