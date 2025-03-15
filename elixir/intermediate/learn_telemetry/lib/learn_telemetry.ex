defmodule LearnTelemetry do
  require Logger

  def run do
    # Make sure we attach our event handlers before triggering events
    attach_handlers()

    # Simulate some operations that will emit telemetry events
    perform_operation("fetch_data", 150)
    perform_operation("process_data", 220)
    perform_operation("store_data", 180)

    Logger.info("All operations completed")
  end

  defp attach_handlers do
    # Attach a handler for all events with the [:learn_telemetry, :operation] prefix
    :telemetry.attach(
      "learn-telemetry-handler",
      [:learn_telemetry, :operation],
      &handle_operation_event/4,
      nil
    )

    # Attach a handler specifically for stop events
    :telemetry.attach(
      "learn-telemetry-stop-handler",
      [:learn_telemetry, :operation, :stop],
      &handle_stop_event/4,
      nil
    )
  end

  defp perform_operation(name, duration_ms) do
    # Start event
    :telemetry.execute(
      [:learn_telemetry, :operation, :start],
      %{system_time: System.system_time()},
      %{name: name}
    )

    # Simulate work
    Process.sleep(duration_ms)

    # Stop event with measurements
    :telemetry.execute(
      [:learn_telemetry, :operation, :stop],
      %{duration: duration_ms},
      %{name: name}
    )
  end

  defp handle_operation_event(event_name, measurements, metadata, _config) do
    Logger.info("Event: #{inspect(event_name)}, Measurements: #{inspect(measurements)}, Metadata: #{inspect(metadata)}")
  end

  defp handle_stop_event([:learn_telemetry, :operation, :stop], %{duration: duration}, %{name: name}, _config) do
    Logger.info("Operation '#{name}' completed in #{duration}ms")
  end
end
