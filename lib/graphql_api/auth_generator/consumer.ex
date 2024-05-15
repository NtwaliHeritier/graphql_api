defmodule GraphqlApi.AuthGenerator.Consumer do
  use GenStage
  alias GraphqlApiWeb.Endpoint
  alias GraphqlApi.MyCache

  @timer Application.compile_env(:graphql_api, :timer)

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(_) do
    {:consumer, %{}, subscribe_to: [GraphqlApi.AuthGenerator.Producer]}
  end

  def handle_subscribe(:producer, _options, from, state) do
    max_demand = 1000
    interval = @timer
    state = Map.put(state, from, {max_demand, interval})
    state = ask_and_schedule(state, from)
    {:manual, state}
  end

  def handle_cancel(_, from, producers) do
    {:noreply, [], Map.delete(producers, from)}
  end

  def handle_events(events, from, state) do
    state =
      Map.update!(state, from, fn {pending, interval} ->
        {pending + length(events), interval}
      end)

    events
    |> List.flatten()
    |> Enum.each(fn event ->
      token =
        :telemetry.span([:emit, :time], %{}, fn ->
          generated_token = Phoenix.Token.sign(Endpoint, event.email, event.id)
          {generated_token, %{}}
        end)

      GraphqlApi.Telemetry.CustomMetrics.emit_generated_tokens()
      MyCache.insert(event.id, token)
    end)

    {:noreply, [], state}
  end

  def handle_info({:request, from}, state) do
    {:noreply, [], ask_and_schedule(state, from)}
  end

  defp ask_and_schedule(producers, from) do
    case producers do
      %{^from => {demand, interval}} ->
        GenStage.ask(from, demand)
        Process.send_after(self(), {:request, from}, interval)
        Map.put(producers, from, {0, interval})

      %{} ->
        producers
    end
  end
end
