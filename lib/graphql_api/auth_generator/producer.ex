defmodule GraphqlApi.AuthGenerator.Producer do
  use GenStage

  alias GraphqlApi.Accounts

  def start_link(_) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_state) do
    state = Accounts.all_user()
    {:producer, state}
  end

  def handle_demand(demand, state) do
    Process.send_after(self(), {:refresh, demand}, 0)
    {:noreply, [], state}
  end

  def handle_info({:refresh, demand}, state) do
    case Enum.slice(state, 0..(demand - 1)) do
      [] ->
        {:noreply, [], Accounts.all_user()}

      users ->
        Process.send_after(self(), {:refresh, demand}, 0)
        {:noreply, [users], Enum.slice(state, demand..-1)}
    end
  end
end
