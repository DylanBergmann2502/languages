defmodule LearnBandit do
  @moduledoc """
  Bandit v1.8 — pure-Elixir HTTP/1, HTTP/2, and WebSocket server.

  Bandit replaces Cowboy as the HTTP server underlying Phoenix (1.7.11+).
  Built on Thousand Island (TCP acceptor pool). Implements Plug and WebSock natively.

  Why Bandit over Cowboy:
    - Pure Elixir (readable, debuggable)
    - 4x faster HTTP/1, 1.5x faster HTTP/2 in benchmarks
    - 100% h2spec and Autobahn WebSocket compliance
    - zstd compression support (OTP 28+)

  deps:
    {:bandit,          "~> 1.8"}
    {:websock_adapter, "~> 0.5"}  # for WebSocket support
  """

  def run do
    IO.puts("\n=== Bandit: Pure-Elixir HTTP Server ===\n")

    basic_http_demo()
    json_api_demo()
    websocket_demo()
    configuration_reference()
    phoenix_integration()
    vs_cowboy()
  end

  # -----------------------------------------------------------------------
  # 1. Basic HTTP server — actually starts, serves requests, stops
  # -----------------------------------------------------------------------
  defp basic_http_demo do
    IO.puts("--- Basic HTTP Server (live demo) ---")

    # Start a real Bandit server on an ephemeral port
    {:ok, server} = Bandit.start_link(plug: DemoRouter, port: 0)
    port = server_port(server)
    IO.puts("Server started on port #{port}")

    # Make real HTTP requests to it
    base = "http://localhost:#{port}"

    resp = Req.get!(base <> "/")
    IO.puts("GET /       → #{resp.status}: #{resp.body}")

    resp = Req.get!(base <> "/hello/world")
    IO.puts("GET /hello/world → #{resp.status}: #{resp.body}")

    resp = Req.get!(base <> "/not-found")
    IO.puts("GET /not-found   → #{resp.status}: #{resp.body}")

    Supervisor.stop(server)
    IO.puts("Server stopped")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. JSON API demo
  # -----------------------------------------------------------------------
  defp json_api_demo do
    IO.puts("--- JSON API (live demo) ---")

    {:ok, server} = Bandit.start_link(plug: JsonApiRouter, port: 0)
    port = server_port(server)

    base = "http://localhost:#{port}"

    # GET returns JSON (auto-decoded by Req)
    resp = Req.get!(base <> "/users")
    IO.puts("GET /users → #{resp.status}: #{inspect(resp.body)}")

    # POST with JSON body
    resp = Req.post!(base <> "/users", json: %{name: "Alice", email: "alice@example.com"})
    IO.puts("POST /users → #{resp.status}: #{inspect(resp.body)}")

    # Request headers
    resp = Req.get!(base <> "/echo",
      headers: %{"x-request-id" => "abc-123", "accept" => "application/json"})
    IO.puts("GET /echo headers → #{inspect(resp.body["x-request-id"])}")

    Supervisor.stop(server)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. WebSocket demo
  # -----------------------------------------------------------------------
  defp websocket_demo do
    IO.puts("--- WebSocket (live demo) ---")

    {:ok, server} = Bandit.start_link(plug: WsRouter, port: 0, websocket_options: [compress: false])
    port = server_port(server)

    # Connect via :gun (Erlang WebSocket client)
    {:ok, conn} = :gun.open('localhost', port, %{protocols: [:http]})
    {:ok, :http} = :gun.await_up(conn)

    stream = :gun.ws_upgrade(conn, "/ws")
    receive do
      {:gun_upgrade, ^conn, ^stream, ["websocket"], _headers} ->
        IO.puts("WebSocket connected")
    after 1000 ->
      IO.puts("WebSocket upgrade timeout")
    end

    # Send a text frame
    :gun.ws_send(conn, stream, {:text, "hello bandit"})
    receive do
      {:gun_ws, ^conn, ^stream, {:text, reply}} ->
        IO.puts("WebSocket echo: #{reply}")
    after 1000 ->
      IO.puts("No WS reply")
    end

    # Send a second message
    :gun.ws_send(conn, stream, {:text, "ping"})
    receive do
      {:gun_ws, ^conn, ^stream, {:text, reply}} ->
        IO.puts("WebSocket reply: #{reply}")
    after 1000 ->
      IO.puts("No WS reply")
    end

    :gun.close(conn)
    Supervisor.stop(server)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Configuration reference
  # -----------------------------------------------------------------------
  defp configuration_reference do
    IO.puts("--- Configuration Reference ---")

    # The full option set — shown as data, not printed as a string
    options = [
      plug: MyApp.Router,
      scheme: :http,           # :http | :https
      port: 4000,
      ip: :any,                # :any | :loopback | {1,2,3,4} | {:local, "/tmp/app.sock"}
      startup_log: :info,

      http_options: [
        compress: true,
        log_protocol_errors: :short
      ],

      http_1_options: [
        enabled: true,
        max_request_line_length: 10_000,
        max_header_length: 10_000,
        max_header_count: 50,
        max_requests: 0           # 0 = unlimited keepalive
      ],

      http_2_options: [
        enabled: true,
        max_header_block_size: 50_000,
        max_reset_stream_rate: {500, 10_000}  # DoS mitigation
      ],

      websocket_options: [
        enabled: true,
        max_frame_size: 8_000_000,
        validate_text_frames: true,
        compress: true
      ],

      thousand_island_options: [
        num_acceptors: 100,
        num_connections: 16_384,
        shutdown_timeout: 15_000
      ]
    ]

    IO.puts("Bandit option categories: #{inspect(Keyword.keys(options))}")

    # HTTPS — key additional options
    https_opts = [scheme: :https, port: 4040, certfile: "priv/cert.pem", keyfile: "priv/key.pem"]
    IO.puts("HTTPS-specific options: #{inspect(Keyword.keys(https_opts))}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Phoenix integration
  # -----------------------------------------------------------------------
  defp phoenix_integration do
    IO.puts("--- Phoenix Integration ---")

    # Phoenix 1.7.11+ uses Bandit by default. For existing Cowboy apps:
    # 1. In mix.exs: replace {:plug_cowboy, ...} with {:bandit, "~> 1.8"}
    # 2. In config/config.exs:
    phoenix_config = [
      adapter: Bandit.PhoenixAdapter,
      url: [host: "localhost"],
      http: [ip: {127, 0, 0, 1}, port: 4000],
      # https: [port: 4040, otp_app: :my_app, certfile: "priv/cert.pem", keyfile: "priv/key.pem"]
    ]

    IO.puts("Phoenix config keys: #{inspect(Keyword.keys(phoenix_config))}")
    IO.puts("Phoenix LiveView WebSockets and Channels work without any changes.")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 6. Bandit vs Cowboy
  # -----------------------------------------------------------------------
  defp vs_cowboy do
    IO.puts("--- Bandit vs Cowboy ---")

    comparison = [
      {"Language",          "Pure Elixir",   "Erlang"},
      {"HTTP/1 speed",      "~4x faster",    "baseline"},
      {"HTTP/2 speed",      "~1.5x faster",  "baseline"},
      {"h2spec compliance", "100%",           "very good"},
      {"Autobahn WS score", "100%",           "very good"},
      {"zstd compression",  "yes (OTP 28+)", "no"},
      {"Phoenix default",   "yes (1.7.11+)", "legacy"},
    ]

    IO.puts("#{String.pad_trailing("Aspect", 24)} #{String.pad_trailing("Bandit", 18)} Cowboy")
    IO.puts(String.duplicate("-", 60))
    Enum.each(comparison, fn {aspect, bandit, cowboy} ->
      IO.puts("#{String.pad_trailing(aspect, 24)} #{String.pad_trailing(bandit, 18)} #{cowboy}")
    end)

    IO.puts("")
  end

  # Get the actual port from a started Bandit server (uses port 0 = OS-assigned)
  defp server_port(server) do
    {:ok, {_ip, port}} = ThousandIsland.listener_info(server)
    port
  end
end

# ============================================================
# Demo Plug routers (defined at top level, not inside LearnBandit)
# ============================================================

defmodule DemoRouter do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Hello from Bandit!")
  end

  get "/hello/:name" do
    send_resp(conn, 200, "Hello, #{name}!")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end

defmodule JsonApiRouter do
  use Plug.Router

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason

  plug :match
  plug :dispatch

  get "/users" do
    users = [%{id: 1, name: "Alice"}, %{id: 2, name: "Bob"}]
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(users))
  end

  post "/users" do
    body = conn.body_params
    created = Map.put(body, "id", System.unique_integer([:positive]))
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(201, Jason.encode!(created))
  end

  get "/echo" do
    headers_map = Map.new(conn.req_headers)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(headers_map))
  end

  match _ do
    send_resp(conn, 404, Jason.encode!(%{error: "not found"}))
  end
end

defmodule EchoHandler do
  @behaviour WebSock

  @impl WebSock
  def init(state), do: {:ok, state}

  @impl WebSock
  def handle_in({msg, [opcode: :text]}, state) do
    {:reply, :ok, {:text, "Echo: #{msg}"}, state}
  end

  def handle_in({data, [opcode: :binary]}, state) do
    {:reply, :ok, {:binary, data}, state}
  end

  @impl WebSock
  def handle_info(_msg, state), do: {:ok, state}

  @impl WebSock
  def terminate(_reason, _state), do: :ok
end

defmodule WsRouter do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/ws" do
    conn
    |> WebSockAdapter.upgrade(EchoHandler, %{}, [])
    |> halt()
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
