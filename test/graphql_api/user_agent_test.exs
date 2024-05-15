# defmodule GraphqlApi.UserAgentTest do
#   use ExUnit.Case, async: true
#   alias GraphqlApi.UserAgent

#   setup do
#     {:ok, pid} = UserAgent.start_link([name: nil])
#     {:ok, %{pid: pid}}
#   end

#   describe "&get_state/2" do
#     test "returns 0 if the key doesn't exist in the state", %{pid: pid} do
#       state = UserAgent.get_state(pid, "get_user")
#       assert state == 0
#     end
#   end

#   describe "&update_state/2" do
#     test "updates state", %{pid: pid} do
#       UserAgent.update_state(pid, "get_user")
#       state = UserAgent.get_state(pid, "get_user")
#       assert state == 1
#       UserAgent.update_state(pid, "get_user")
#       state = UserAgent.get_state(pid, "get_user")
#       assert state == 2
#     end
#   end
# end
