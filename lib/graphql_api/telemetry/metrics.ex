defmodule GraphqlApi.Telemetry.Metrics do
  use Supervisor
  alias PrometheusTelemetry.Metrics.{GraphQL, Ecto, Phoenix}
  alias GraphqlApi.Telemetry.CustomMetrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    children = [
      {PrometheusTelemetry,
       exporter: [enabled?: true],
       metrics: [
         GraphQL.metrics(),
         Ecto.metrics_for_repo(GraphqlApi.Repo),
         CustomMetrics.metrics(),
         Phoenix.metrics()
       ]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
