defmodule GraphqlApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    topologies = [
      graphql_api: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:node_a@localhost, :node_b@localhost]]
      ]
    ]

    children = [
      # Start the Telemetry supervisor
      GraphqlApiWeb.Telemetry,
      {GraphqlApi.Repo, []},
      # Start the PubSub system
      {Phoenix.PubSub, name: GraphqlApi.PubSub},
      # Start the Endpoint (http/https)
      GraphqlApiWeb.Endpoint,
      # Start a worker by calling: GraphqlApi.Worker.start_link(arg)
      # {GraphqlApi.Worker, arg}
      {Absinthe.Subscription, pubsub: GraphqlApiWeb.Endpoint},
      # {GraphqlApi.UserAgent, []},
      # :poolboy.child_spec(:user_worker,
      #   name: {:local, :user_worker},
      #   worker_module: GraphqlApi.UserAgent,
      #   size: 3,
      #   max_overflow: 2
      # ),
      {GraphqlApi.MyCache, []},
      {GraphqlApi.Telemetry.Metrics, []},
      {GraphqlApi.AuthGenerator.Producer, []},
      {GraphqlApi.AuthGenerator.Consumer, []},
      {Cluster.Supervisor, [topologies, [name: GraphqlApi.ClusterSupervisor]]},
      # {Redix, [name: :redis]},
      # {GraphqlApi.RedisCache, []},
      {Cache, [GraphqlApi.RedisCache]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GraphqlApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GraphqlApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
