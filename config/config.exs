# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :graphql_api,
  ecto_repos: [GraphqlApi.Repo]

config :ecto_shorts,
  repo: GraphqlApi.Repo,
  error_module: EctoShorts.Actions.Error

# Configures the endpoint
config :graphql_api, GraphqlApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Mhsm8nWH0CcbMidZ/vGz0h7b37+30k2Uv2arPAaKITWn+FUJhzX5qKquYsOEMvVc",
  render_errors: [view: GraphqlApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: GraphqlApi.PubSub,
  live_view: [signing_salt: "6a0DHRcU"]

config :graphql_api, timer: :timer.hours(24)

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# config request cache plug
config :request_cache_plug,
  enabled?: true,
  verbose?: false,
  graphql_paths: ["/graphiql", "/graphql", "/api/graphiql", "/api/graphql"],
  conn_priv_key: :__shared_request_cache__,
  request_cache_module: GraphqlApi.RedisCache,
  default_ttl: :timer.hours(1)

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
