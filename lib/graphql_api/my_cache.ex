defmodule GraphqlApi.MyCache do
  use GenServer
  alias __MODULE__

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(_) do
    table =
      :ets.new(:graphql_api_cache, [
        :public,
        :named_table,
        :compressed,
        :set,
        read_concurrency: true,
        write_concurrency: true
      ])

    {:ok, %{table: table}}
  end

  def insert(key, value) do
    if node() === :node_a@localhost do
      :ets.insert(:graphql_api_cache, {key, value})
    else
      :rpc.call(:node_a@localhost, MyCache, :insert, [key, value])
    end
  end

  def get(key) do
    if node() === :node_a@localhost do
      :ets.lookup(:graphql_api_cache, key)
    else
      :rpc.call(:node_a@localhost, MyCache, :get, [key])
    end
  end

  def update_requests(key) do
    if node() === :node_a@localhost do
      check_race_condition(key)
    else
      :rpc.call(:node_a@localhost, MyCache, :update_requests, [key])
    end
  end

  defp check_race_condition(key) do
    case :ets.lookup(:graphql_api_cache, :update_time) do
      [] ->
        update_change(key, false)

      [{_, result}] ->
        update_change(key, DateTime.compare(result, DateTime.utc_now()) === :eq)
    end
  end

  defp update_change(key, true) do
    :ets.insert(:graphql_api_cache, {:update_time, DateTime.utc_now()})
    :ets.update_counter(:graphql_api_cache, key, 2, {key, 1})
  end

  defp update_change(key, false) do
    :ets.insert(:graphql_api_cache, {:update_time, DateTime.utc_now()})
    :ets.update_counter(:graphql_api_cache, key, 1, {key, 0})
  end
end
