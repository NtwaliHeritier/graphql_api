defmodule GraphqlApi.Telemetry.CustomMetrics do
  import Telemetry.Metrics

  @event_prefix [:emit]

  def metrics do
    [
      counter("emit.generated_tokens",
        event_name: @event_prefix ++ [:tokens_generated],
        measurement: :count
      ),
      counter("emit.time.start.counter",
        event_name: @event_prefix ++ [:time, :start],
        measurement: :system_time
      ),
      counter("emit.time.exception.counter",
        event_name: @event_prefix ++ [:time, :exception],
        measurement: :error
      ),
      distribution("emit.time.stop.distribution.millisecond",
        event_name: @event_prefix ++ [:time, :stop],
        measurement: :duration,
        unit: {:native, :millisecond},
        reporter_options: [
          buckets: [200, 500, 1000]
        ]
      )
    ]
  end

  def emit_generated_tokens, do: :telemetry.execute([:emit, :tokens_generated], %{count: 1})
end
