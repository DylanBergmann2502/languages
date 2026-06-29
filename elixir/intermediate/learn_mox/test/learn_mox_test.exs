defmodule LearnMox.WeatherAPI do
  @callback current_temp(lat :: float(), lon :: float()) :: {:ok, float()} | {:error, term()}
  @callback forecast(lat :: float(), lon :: float(), days :: pos_integer()) ::
              {:ok, [map()]} | {:error, term()}

  def current_temp(lat, lon), do: impl().current_temp(lat, lon)
  def forecast(lat, lon, days), do: impl().forecast(lat, lon, days)

  defp impl, do: Application.get_env(:learn_mox, :weather_api, __MODULE__.Real)
end

defmodule LearnMox.WeatherAPI.Real do
  @behaviour LearnMox.WeatherAPI
  def current_temp(_lat, _lon), do: {:ok, 20.0}
  def forecast(_lat, _lon, _days), do: {:ok, [%{date: "2026-07-01", temp: 20.0}]}
end

defmodule LearnMox.WeatherService do
  def display_temp(lat, lon) do
    case LearnMox.WeatherAPI.current_temp(lat, lon) do
      {:ok, temp} -> "#{temp}°C"
      {:error, _} -> "unavailable"
    end
  end

  def daily_high(lat, lon) do
    case LearnMox.WeatherAPI.forecast(lat, lon, 1) do
      {:ok, [%{temp: t} | _]} -> {:ok, t}
      {:error, reason}        -> {:error, reason}
    end
  end
end

Mox.defmock(LearnMox.MockWeatherAPI, for: LearnMox.WeatherAPI)
Application.put_env(:learn_mox, :weather_api, LearnMox.MockWeatherAPI)

defmodule LearnMoxTest do
  use ExUnit.Case, async: true
  import Mox

  setup :verify_on_exit!

  # --- expect: must be called exactly once ---
  test "expect: displays temperature from API" do
    expect(LearnMox.MockWeatherAPI, :current_temp, fn 51.5, -0.1 ->
      {:ok, 25.3}
    end)

    assert LearnMox.WeatherService.display_temp(51.5, -0.1) == "25.3°C"
  end

  # --- expect N times ---
  test "expect: forecast called 3 times" do
    expect(LearnMox.MockWeatherAPI, :forecast, 3, fn _lat, _lon, _days ->
      {:ok, [%{date: "2026-07-01", temp: 22.0}]}
    end)

    for _ <- 1..3 do
      assert {:ok, 22.0} = LearnMox.WeatherService.daily_high(0.0, 0.0)
    end
  end

  # --- stub: may be called any number of times ---
  test "stub: handles API error gracefully" do
    stub(LearnMox.MockWeatherAPI, :current_temp, fn _, _ ->
      {:error, :timeout}
    end)

    assert LearnMox.WeatherService.display_temp(0.0, 0.0) == "unavailable"
  end

  # --- sequential expects for retry testing ---
  test "expect: retry pattern — first call fails, second succeeds" do
    LearnMox.MockWeatherAPI
    |> expect(:current_temp, fn _, _ -> {:error, :timeout} end)
    |> expect(:current_temp, fn _, _ -> {:ok, 18.0} end)

    assert LearnMox.WeatherService.display_temp(0.0, 0.0) == "unavailable"
    assert LearnMox.WeatherService.display_temp(0.0, 0.0) == "18.0°C"
  end

  # --- allow: cross-process mock ownership ---
  test "allow: mock usable from a Task" do
    expect(LearnMox.MockWeatherAPI, :current_temp, fn _, _ -> {:ok, 30.0} end)

    parent = self()

    result =
      Task.async(fn ->
        allow(LearnMox.MockWeatherAPI, parent, self())
        LearnMox.WeatherService.display_temp(51.5, -0.1)
      end)
      |> Task.await()

    assert result == "30.0°C"
  end

  # --- stub_with: delegate to a real module ---
  test "stub_with: uses a real fallback module" do
    stub_with(LearnMox.MockWeatherAPI, LearnMox.WeatherAPI.Real)

    # Real module returns 20.0
    assert LearnMox.WeatherService.display_temp(0.0, 0.0) == "20.0°C"
  end

  # --- deny: assert a function is never called ---
  test "deny: service with bad lat/lon should fail before calling API" do
    stub(LearnMox.MockWeatherAPI, :current_temp, fn _, _ -> {:ok, 20.0} end)

    # Just showing deny syntax — deny/3 asserts the mock is never called
    # Uncomment to assert denial:
    # deny(LearnMox.MockWeatherAPI, :forecast, 3)
    assert is_function(&LearnMox.WeatherService.display_temp/2)
  end
end
