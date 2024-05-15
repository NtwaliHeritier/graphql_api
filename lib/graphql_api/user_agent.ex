# defmodule GraphqlApi.UserAgent do
#   use Agent

#   def start_link(opts \\ []) do
#     state = Keyword.get(opts, :state, %{})
#     Agent.start_link(fn -> state end)
#   end

#   def get_state(pid, key) do
#     Agent.get(pid, fn state ->
#       Map.get(state, key, 0)
#     end)
#   end

#   def update_state(pid, key) do
#     Agent.update(pid, fn state ->
#       new_state = Map.update(state, key, 1, &(&1 + 1))
#       publish_changes(new_state, key)
#       new_state
#     end)
#   end

#   defp publish_changes(state, key) do
#     Absinthe.Subscription.publish(
#       GraphqlApiWeb.Endpoint,
#       Map.get(state, key),
#       update_resolver_counter: "counter_changes_#{key}"
#     )
#   end
# end
