defmodule LearnBandit do
  @moduledoc """
  Bandit v1.8 — pure-Elixir HTTP/1, HTTP/2, and WebSocket server.

  Bandit replaces Cowboy as the HTTP server underlying Phoenix (1.7.11+).
  It's built on Thousand Island (TCP/TLS acceptor pool) and implements
  the Plug and WebSock protocols natively.

  Why Bandit over Cowboy?
    - Pure Elixir — easier to read, debug, and contribute to
    - 4x faster HTTP/1, 1.5x faster HTTP/2 in benchmarks
    - 100% h2spec and Autobahn WebSocket compliance
    - zstd compression support (Erlang/OTP 28+)
    - Built specifically for the Plug ecosystem

  Setup in mix.exs:
    {:bandit, "~> 1.8"},
    {:websock_adapter, "~> 0.5"}  # for WebSocket support
  """

  def run do
    IO.puts("\n=== Bandit: Pure-Elixir HTTP Server ===\n")

    basic_http()
    configuration_options()
    https_setup()
    websocket_pattern()
    phoenix_integration()
    vs_cowboy()
  end

  # -----------------------------------------------------------------------
  # 1. Basic HTTP server
  # -----------------------------------------------------------------------
  defp basic_http do
    IO.puts("--- Basic HTTP Server ---")

    IO.puts("""
    # Minimal Plug + Bandit server

    defmodule MyApp.Router do
      use Plug.Router

      plug :match
      plug :dispatch

      get "/" do
        send_resp(conn, 200, "Hello from Bandit!")
      end

      get "/health" do
        send_resp(conn, 200, Jason.encode!(%{status: "ok"}))
      end

      post "/echo" do
        {:ok, body, conn} = Plug.Conn.read_body(conn)
        send_resp(conn, 200, body)
      end

      match _ do
        send_resp(conn, 404, "Not found")
      end
    end

    # Start standalone (e.g. in IEx or a script):
    Bandit.start_link(plug: MyApp.Router, port: 4000)

    # In a supervision tree (typical for production):
    defmodule MyApp.Application do
      use Application

      def start(_type, _args) do
        children = [
          {Bandit, plug: MyApp.Router, port: 4000}
        ]
        Supervisor.start_link(children, strategy: :one_for_one)
      end
    end
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Configuration options
  # -----------------------------------------------------------------------
  defp configuration_options do
    IO.puts("--- Configuration Options ---")

    IO.puts("""
    {Bandit,
      # Required
      plug: MyApp.Router,         # Plug module or {module, opts}

      # Network
      scheme: :http,              # :http (default) or :https
      port:   4000,               # default: 4000 (:http), 4040 (:https)
      ip:     :any,               # :any, :loopback, {1,2,3,4}, {:local, "/tmp/app.sock"}

      # Logging
      startup_log: :info,         # Logger level or false

      # HTTP options (shared HTTP/1 and HTTP/2)
      http_options: [
        compress: true,           # gzip/deflate/zstd response compression (default: true)
        log_protocol_errors: :short,  # :short | :verbose | false
        log_exceptions_with_status_codes: 500..599
      ],

      # HTTP/1 options
      http_1_options: [
        enabled: true,
        max_request_line_length: 10_000,  # bytes
        max_header_length: 10_000,        # bytes per header
        max_header_count: 50,
        max_requests: 0,                  # 0 = unlimited keepalive requests
        gc_every_n_keepalive_requests: 5
      ],

      # HTTP/2 options
      http_2_options: [
        enabled: true,
        max_header_block_size: 50_000,    # compressed header block bytes
        max_requests: 0,                  # 0 = unlimited
        max_reset_stream_rate: {500, 10_000}  # {count, window_ms} — DoS mitigation
      ],

      # WebSocket options
      websocket_options: [
        enabled: true,
        max_frame_size: 8_000_000,             # bytes per frame
        max_fragmented_message_size: 8_000_000, # total multi-frame message
        validate_text_frames: true,             # UTF-8 validation
        compress: true                          # per-message deflate
      ],

      # Thousand Island (TCP acceptor pool) options — advanced
      thousand_island_options: [
        num_acceptors: 100,
        num_connections: 16_384,
        shutdown_timeout: 15_000
      ]
    }
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. HTTPS/TLS
  # -----------------------------------------------------------------------
  defp https_setup do
    IO.puts("--- HTTPS / TLS ---")

    IO.puts("""
    # Self-signed cert for dev (generate with mix phx.gen.cert or openssl):
    # openssl req -newkey rsa:4096 -nodes -keyout priv/key.pem -x509 -days 365 -out priv/cert.pem

    {Bandit,
      plug:     MyApp.Router,
      scheme:   :https,
      port:     4040,
      certfile: "priv/cert.pem",
      keyfile:  "priv/key.pem",
      # cipher_suite: :strong     # or :compatible (broader client support)
      # otp_app: :my_app          # makes certfile/keyfile relative to app priv/
    }

    # With otp_app (path resolved to priv/ dir of the app):
    {Bandit,
      plug:     MyApp.Router,
      scheme:   :https,
      port:     4040,
      otp_app:  :my_app,
      certfile: "cert.pem",    # → priv/cert.pem
      keyfile:  "key.pem"      # → priv/key.pem
    }

    # Production: use SNI and multiple certs via thousand_island_options:
    {Bandit,
      plug: MyApp.Router,
      scheme: :https,
      thousand_island_options: [
        transport_options: [
          sni_fun: fn host ->
            certs_for_host(host)  # returns [{:certfile, ...}, {:keyfile, ...}]
          end
        ]
      ]
    }
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. WebSocket
  # -----------------------------------------------------------------------
  defp websocket_pattern do
    IO.puts("--- WebSocket Support ---")

    IO.puts("""
    # WebSocket support via WebSockAdapter (separate dep: {:websock_adapter, "~> 0.5"})
    # Bandit handles the HTTP Upgrade, WebSockAdapter bridges to your handler.

    # 1. A Plug that upgrades specific paths to WebSocket:
    defmodule MyApp.WebPlug do
      use Plug.Router

      plug :match
      plug :dispatch

      get "/ws" do
        conn
        |> WebSockAdapter.upgrade(MyApp.ChatHandler, %{user_id: "anon"}, compress: true)
        |> halt()
      end

      get "/" do
        send_resp(conn, 200, "Connect to /ws for WebSocket")
      end
    end

    # 2. WebSocket handler (WebSock behaviour):
    defmodule MyApp.ChatHandler do
      @behaviour WebSock

      @impl WebSock
      def init(state) do
        # Called after WebSocket handshake
        {:ok, state}
      end

      @impl WebSock
      def handle_in({message, [opcode: :text]}, state) do
        # Reply with text frame
        {:reply, :ok, {:text, "Echo: \#{message}"}, state}
      end

      def handle_in({_data, [opcode: :binary]}, state) do
        {:reply, :ok, {:binary, "binary ack"}, state}
      end

      @impl WebSock
      def handle_info({:broadcast, msg}, state) do
        # Send a server-initiated message
        {:push, {:text, msg}, state}
      end

      @impl WebSock
      def terminate(_reason, _state), do: :ok
    end

    # 3. Start with WebSocket enabled (default):
    Bandit.start_link(
      plug: MyApp.WebPlug,
      port: 4000,
      websocket_options: [compress: true, max_frame_size: 1_000_000]
    )

    # Return values from WebSock callbacks:
    {:ok, state}                        # no reply
    {:reply, :ok, frame_or_frames, state}  # send frame(s)
    {:push, frame_or_frames, state}     # alias for :reply
    {:stop, :normal, state}             # close connection

    # Frame formats:
    {:text, "string"}
    {:binary, <<bytes>>}
    :ping
    :pong
    {:close, 1000, "bye"}
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Phoenix integration
  # -----------------------------------------------------------------------
  defp phoenix_integration do
    IO.puts("--- Phoenix Integration ---")

    IO.puts("""
    # Phoenix 1.7.11+ uses Bandit by default for new projects.
    # For existing projects using Cowboy, switching is one config change:

    # mix.exs — replace {:plug_cowboy, ...} with {:bandit, ...}
    defp deps do
      [
        {:phoenix, "~> 1.8"},
        {:bandit, "~> 1.8"},      # ← add this
        # {:plug_cowboy, ...}     # ← remove this
      ]
    end

    # config/config.exs
    config :my_app, MyAppWeb.Endpoint,
      adapter: Bandit.PhoenixAdapter,   # ← key line
      url: [host: "localhost"],
      http: [
        ip: {127, 0, 0, 1},
        port: 4000,
        http_1_options: [max_requests: 0],
        websocket_options: [compress: true]
      ]

    # For HTTPS in config/runtime.exs:
    config :my_app, MyAppWeb.Endpoint,
      https: [
        port: 4040,
        otp_app: :my_app,
        certfile: "priv/cert.pem",
        keyfile:  "priv/key.pem"
      ]

    # Phoenix LiveView WebSockets work out of the box —
    # Bandit handles the WS upgrade transparently.
    # Phoenix Channels (via socket) also work without any changes.
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 6. Bandit vs Cowboy
  # -----------------------------------------------------------------------
  defp vs_cowboy do
    IO.puts("--- Bandit vs Cowboy ---")

    IO.puts("""
    ┌─────────────────────────┬─────────────────┬─────────────────┐
    │ Aspect                  │ Bandit          │ Cowboy          │
    ├─────────────────────────┼─────────────────┼─────────────────┤
    │ Language                │ Pure Elixir     │ Erlang          │
    │ HTTP/1 speed            │ ~4x faster      │ baseline        │
    │ HTTP/2 speed            │ ~1.5x faster    │ baseline        │
    │ h2spec compliance       │ 100%            │ very good       │
    │ Autobahn (WS) score     │ 100%            │ very good       │
    │ zstd compression        │ yes (OTP 28+)   │ no              │
    │ Code readability        │ high (Elixir)   │ lower (Erlang)  │
    │ Phoenix default         │ yes (1.7.11+)   │ legacy default  │
    │ Drop-in replacement     │ yes             │ —               │
    │ Thousand Island         │ yes (TCP layer) │ ranch (Erlang)  │
    └─────────────────────────┴─────────────────┴─────────────────┘

    When to still use Cowboy:
      - You depend on Cowboy-specific middleware not in Plug
      - You need :ranch for non-HTTP TCP protocols alongside HTTP
      - Existing project with complex Cowboy configuration

    When to use Bandit:
      - New projects (it's the Phoenix default)
      - You want better HTTP/2 and WebSocket compliance
      - You want zstd support
      - You want debuggable Elixir code all the way down
    """)
    IO.puts("")
  end
end
