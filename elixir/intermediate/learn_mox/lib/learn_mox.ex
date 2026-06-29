defmodule LearnMox do
  @moduledoc """
  Mox v1.2 — behaviour-based mocking for Elixir.

  Mox enforces a key principle: mocks must implement a real @behaviour.
  This prevents mocking things that don't exist in production, and keeps
  your test doubles in sync with your real interfaces.

  The pattern:
    1. Define a @behaviour (your interface contract)
    2. Have your real implementation use it
    3. Call through an indirection point (Application config or injected)
    4. In tests: defmock, stub/expect, verify

  Key distinction:
    stub/3   — "this may be called, I don't care how many times"
    expect/4 — "this MUST be called exactly N times" (verified on exit)
    deny/3   — "this must NOT be called"

  Setup in mix.exs:
    {:mox, "~> 1.2", only: :test}
  """

  def run do
    IO.puts("\n=== Mox: Behaviour-Based Mocking ===\n")
    IO.puts("Mox is a test-only library. This module explains the patterns.")
    IO.puts("The real demos live in test/learn_mox_test.exs\n")

    behaviour_pattern()
    stub_vs_expect()
    async_and_allow()
    global_vs_private()
    deny_pattern()
    best_practices()
  end

  defp behaviour_pattern do
    IO.puts("--- The Behaviour Pattern ---")
    IO.puts("""
    # Step 1: Define your interface as a @behaviour
    defmodule MyApp.WeatherAPI do
      @callback current_temp(lat :: float(), lon :: float()) :: {:ok, float()} | {:error, term()}
      @callback forecast(lat :: float(), lon :: float(), days :: pos_integer()) ::
                  {:ok, [map()]} | {:error, term()}

      # Indirection: calls whatever impl is configured
      def current_temp(lat, lon), do: impl().current_temp(lat, lon)
      def forecast(lat, lon, days), do: impl().forecast(lat, lon, days)

      defp impl, do: Application.get_env(:my_app, :weather_api, MyApp.OpenWeatherAPI)
    end

    # Step 2: Real implementation
    defmodule MyApp.OpenWeatherAPI do
      @behaviour MyApp.WeatherAPI

      def current_temp(lat, lon) do
        # ... real HTTP call ...
        {:ok, 23.5}
      end

      def forecast(lat, lon, days) do
        # ... real HTTP call ...
        {:ok, []}
      end
    end

    # Step 3: In test/support/mocks.ex (compiled only in :test)
    Mox.defmock(MyApp.MockWeatherAPI, for: MyApp.WeatherAPI)

    # Step 4: In test/test_helper.exs
    Application.put_env(:my_app, :weather_api, MyApp.MockWeatherAPI)
    ExUnit.start()
    """)
    IO.puts("")
  end

  defp stub_vs_expect do
    IO.puts("--- stub/3 vs expect/4 ---")
    IO.puts("""
    import Mox

    # stub/3 — may be called any number of times (including zero)
    # Does NOT assert it was called. Use for background/incidental calls.
    stub(MyApp.MockWeatherAPI, :current_temp, fn _lat, _lon ->
      {:ok, 20.0}
    end)

    # expect/4 — MUST be called exactly N times (default: 1)
    # verify_on_exit! will raise if the expectation isn't met.
    expect(MyApp.MockWeatherAPI, :current_temp, fn _lat, _lon ->
      {:ok, 25.0}
    end)

    # expect N times
    expect(MyApp.MockWeatherAPI, :forecast, 3, fn _lat, _lon, _days ->
      {:ok, [%{date: "2026-07-01", temp: 22.0}]}
    end)

    # Chain expectations for sequential calls (retry testing):
    MyApp.MockWeatherAPI
    |> expect(:current_temp, fn _, _ -> {:error, :timeout} end)   # 1st call fails
    |> expect(:current_temp, fn _, _ -> {:ok, 25.0} end)           # 2nd call succeeds

    # stub_with/2 — delegate ALL behaviour callbacks to a real module
    defmodule MyApp.FakeWeatherAPI do
      @behaviour MyApp.WeatherAPI
      def current_temp(_lat, _lon), do: {:ok, 20.0}
      def forecast(_lat, _lon, _days), do: {:ok, []}
    end

    stub_with(MyApp.MockWeatherAPI, MyApp.FakeWeatherAPI)
    """)
    IO.puts("")
  end

  defp async_and_allow do
    IO.puts("--- Async Tests and allow/3 ---")
    IO.puts("""
    # By default (private mode), mocks are owned by the test process.
    # Child processes (Tasks, GenServers) can't use them without allow/3.

    test "mock used from a Task", async: true do
      expect(MyApp.MockWeatherAPI, :current_temp, fn _, _ -> {:ok, 25.0} end)

      parent = self()

      task = Task.async(fn ->
        allow(MyApp.MockWeatherAPI, parent, self())
        MyApp.WeatherAPI.current_temp(51.5, -0.1)
      end)

      assert {:ok, 25.0} = Task.await(task)
    end

    # Lazy allow (for processes started before the test, like GenServers):
    allow(MyApp.MockWeatherAPI, self(), fn ->
      GenServer.whereis(MyApp.WeatherCache)
    end)

    # Task.async is common enough that this pattern is typical:
    test "concurrent mock calls" do
      stub(MyApp.MockWeatherAPI, :current_temp, fn _, _ -> {:ok, 20.0} end)

      results =
        [{51.5, -0.1}, {48.8, 2.3}, {40.7, -74.0}]
        |> Enum.map(fn {lat, lon} ->
          parent = self()
          Task.async(fn ->
            allow(MyApp.MockWeatherAPI, parent, self())
            MyApp.WeatherAPI.current_temp(lat, lon)
          end)
        end)
        |> Task.await_many()

      assert Enum.all?(results, &match?({:ok, _}, &1))
    end
    """)
    IO.puts("")
  end

  defp global_vs_private do
    IO.puts("--- Global vs Private Mode ---")
    IO.puts("""
    # Private mode (default) — safe for async: true
    # Only the owning process (and explicitly allowed children) can call mocks.
    setup :verify_on_exit!   # that's all you need for private mode

    # Global mode — any process can use the mock, no allow/3 needed
    # But: cannot use with async: true (raises at runtime)
    setup :set_mox_global
    setup :verify_on_exit!

    # Auto mode — picks private for async: true, global otherwise
    setup :set_mox_from_context
    setup :verify_on_exit!

    # verify_on_exit!/1 — ALWAYS include this
    # It auto-verifies all expect/4 assertions when the test exits.
    # Without it, unmet expectations silently pass.

    # Full test module template:
    defmodule MyApp.WeatherServiceTest do
      use ExUnit.Case, async: true
      import Mox

      setup :verify_on_exit!

      test "returns formatted temperature" do
        expect(MyApp.MockWeatherAPI, :current_temp, fn 51.5, -0.1 ->
          {:ok, 25.3}
        end)

        assert MyApp.WeatherService.display_temp(51.5, -0.1) == "25.3°C"
      end

      test "handles API error" do
        expect(MyApp.MockWeatherAPI, :current_temp, fn _, _ ->
          {:error, :timeout}
        end)

        assert {:error, :api_unavailable} = MyApp.WeatherService.display_temp(0.0, 0.0)
      end
    end
    """)
    IO.puts("")
  end

  defp deny_pattern do
    IO.puts("--- deny/3 ---")
    IO.puts("""
    # deny/3 — assert a function is NEVER called
    # Useful for negative testing (e.g. no API call on cache hit)

    test "uses cache, does not call API" do
      # Prime the cache
      MyApp.WeatherCache.put({51.5, -0.1}, {:ok, 20.0})

      # Assert the API is never called
      deny(MyApp.MockWeatherAPI, :current_temp, 2)

      # This should use the cache
      assert {:ok, 20.0} = MyApp.WeatherService.current_temp(51.5, -0.1)
    end

    # If current_temp/2 IS called, the test fails with:
    # (Mox.UnexpectedCallError) no expectation defined for
    # MyApp.MockWeatherAPI.current_temp/2 in process ...
    """)
    IO.puts("")
  end

  defp best_practices do
    IO.puts("--- Best Practices ---")
    IO.puts("""
    1. Define mocks ONCE in test/support/mocks.ex, not in each test file:
         Mox.defmock(MyApp.MockWeatherAPI, for: MyApp.WeatherAPI)

    2. Always set the impl via Application config, not hard-coded modules:
         defp impl, do: Application.get_env(:my_app, :weather_api, MyApp.RealAPI)

    3. Always use setup :verify_on_exit! — without it, failed expects go unnoticed.

    4. Prefer stub/3 for setup, expect/4 for the specific call under test:
         setup do
           stub(MyApp.MockWeatherAPI, :current_temp, fn _, _ -> {:ok, 20.0} end)
           :ok
         end
         test "caches the result" do
           expect(MyApp.MockWeatherAPI, :current_temp, fn _, _ -> {:ok, 25.0} end)
           # expect ensures the API is called exactly once, even with caching
         end

    5. Keep mock functions simple — they're test fixtures, not implementations.

    6. Don't mock what you own — only mock boundaries (external APIs, DBs, etc.)
       For your own modules, test through them or use ExUnit test doubles.

    7. Multiple behaviours in one mock:
         Mox.defmock(MyMock, for: [BehaviourA, BehaviourB])
    """)
    IO.puts("")
  end
end
