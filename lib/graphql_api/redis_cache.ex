defmodule GraphqlApi.RedisCache do
  use Cache,
    name: :redis,
    adapter: Cache.Redis,
    opts: [uri: "redis://localhost:6379"]

  # @pool_name :redis_pool
  # @pool_size 10
  # @max_overflow 10

  # def child_spec(opts) do
  #   :poolboy.child_spec(
  #     @pool_name,
  #     name: {:local, @pool_name},
  #     worker_module: Redix,
  #     size: opts[:pool_size] || @pool_size,
  #     max_overflow: opts[:max_overflow] || @max_overflow
  #   )
  # end

  # def put(key, ttl, value) do
  #   :poolboy.transaction(@pool_name, fn pid ->
  #     with {:ok, "OK"} <-
  #            Redix.command(pid, ["SET", key, :erlang.term_to_binary(value), "EX", ttl]) do
  #       :ok
  #     end
  #   end)
  # end

  # def get(key) do
  #   :poolboy.transaction(@pool_name, fn pid ->
  #     Redix.command(pid, ["GET", key]) |> IO.inspect()

  #     with {:ok, value} <- Redix.command(pid, ["GET", key]) do
  #       if is_binary(value) do
  #         :erlang.binary_to_term(value)
  #       else
  #         value
  #       end
  #     end
  #   end)
  # end
end
