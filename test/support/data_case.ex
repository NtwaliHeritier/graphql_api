defmodule GraphqlApiWeb.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias GraphqlApi.Repo
      alias GraphqlApi.Accounts
      alias GraphqlApi.Accounts.User

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import GraphqlApiWeb.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GraphqlApi.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(GraphqlApi.Repo, {:shared, self()})
    end

    :ok
  end
end
