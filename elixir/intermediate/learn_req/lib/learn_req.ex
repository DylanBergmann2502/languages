defmodule LearnReq do
  @moduledoc """
  Req v0.5 — modern, batteries-included HTTP client for Elixir.

  Req is the current standard for HTTP in Elixir, replacing HTTPoison.
  It's built on Finch (which uses Mint and NimblePool), and composes
  request/response logic as a pipeline of steps — each step can inspect
  or modify the request and response.

  Key features:
    - Automatic JSON encode/decode
    - Automatic decompression (gzip, brotli, zstd)
    - Retries with configurable backoff
    - Authentication helpers (basic, bearer, digest, netrc, AWS SigV4)
    - Streaming (into a file, IO, callback, or mailbox)
    - Plug-based testing (no real HTTP needed in tests)
    - Composable via base Req structs and custom steps

  Setup in mix.exs:
    {:req, "~> 0.5"}
  """

  def run do
    IO.puts("\n=== Req: Modern HTTP Client ===\n")

    basic_requests()
    response_struct()
    base_url_pattern()
    authentication()
    request_body()
    streaming()
    retry_and_errors()
    custom_steps()
    testing_with_plug()
  end

  # -----------------------------------------------------------------------
  # 1. Basic requests
  # -----------------------------------------------------------------------
  defp basic_requests do
    IO.puts("--- Basic Requests ---")

    IO.puts("""
    # GET — simplest usage
    resp = Req.get!("https://httpbin.org/get")
    resp.status    #=> 200
    resp.body      #=> %{"url" => "https://httpbin.org/get", ...}

    # Automatic JSON decode (Content-Type: application/json → decoded map)
    resp = Req.get!("https://httpbin.org/json")
    resp.body["slideshow"]["title"]
    #=> "Sample Slide Show"

    # !-variants raise on network error or (optionally) HTTP errors
    # Non-! variants return {:ok, response} | {:error, exception}
    case Req.get("https://httpbin.org/get") do
      {:ok, resp}  -> IO.puts("Got \#{resp.status}")
      {:error, err} -> IO.puts("Failed: \#{inspect(err)}")
    end

    # All HTTP methods:
    Req.get!("https://httpbin.org/get")
    Req.head!("https://httpbin.org/get")
    Req.post!("https://httpbin.org/post", json: %{hello: "world"})
    Req.put!("https://httpbin.org/put",   json: %{updated: true})
    Req.patch!("https://httpbin.org/patch", json: %{field: "value"})
    Req.delete!("https://httpbin.org/delete")

    # run/1,2 — returns {request, response} (useful for debugging)
    {req, resp} = Req.run("https://httpbin.org/get")
    {req.url.host, resp.status}
    #=> {"httpbin.org", 200}

    # Query parameters
    resp = Req.get!("https://httpbin.org/get", params: [page: 1, per_page: 20])
    resp.body["args"]
    #=> %{"page" => "1", "per_page" => "20"}

    # Custom headers
    resp = Req.get!("https://httpbin.org/headers",
      headers: %{"x-custom-header" => "my-value"})
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Req.Response struct
  # -----------------------------------------------------------------------
  defp response_struct do
    IO.puts("--- Req.Response Struct ---")

    IO.puts("""
    %Req.Response{
      status:   200,          # HTTP status code
      headers:  %{},          # map of header_name => [value, ...]
      body:     term(),       # decoded body (map, binary, etc.)
      trailers: %{},          # HTTP trailers
      assigns:  %{},          # user-assigned data (propagated from request)
      private:  %{}           # reserved for libraries
    }

    # Working with headers:
    resp = Req.get!("https://httpbin.org/get")
    Req.Response.get_header(resp, "content-type")
    #=> ["application/json"]

    # Check status programmatically:
    resp.status in 200..299   #=> true
    resp.status == 404        #=> false
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. Base URL pattern — build reusable clients
  # -----------------------------------------------------------------------
  defp base_url_pattern do
    IO.puts("--- Base URL Pattern ---")

    IO.puts("""
    # Build a reusable base request with shared config
    github = Req.new(
      base_url: "https://api.github.com",
      auth: {:bearer, System.get_env("GITHUB_TOKEN", "")},
      headers: %{"accept" => "application/vnd.github.v3+json"}
    )

    # Reuse across many calls — options merge:
    elixir_repo = Req.get!(github, url: "/repos/elixir-lang/elixir")
    req_repo    = Req.get!(github, url: "/repos/wojtekmach/req")

    IO.puts(elixir_repo.body["description"])
    IO.puts(req_repo.body["description"])

    # Path params (template substitution):
    resp = Req.get!("https://httpbin.org/status/:code",
      path_params: [code: 200])
    resp.status  #=> 200

    # Curly-brace style:
    Req.get!("https://api.example.com/users/{id}",
      path_params: [id: 42],
      path_params_style: :curly)
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Authentication
  # -----------------------------------------------------------------------
  defp authentication do
    IO.puts("--- Authentication ---")

    IO.puts("""
    # Basic auth
    Req.get!("https://httpbin.org/basic-auth/user/pass",
      auth: {:basic, "user:pass"})

    # Bearer token
    Req.get!("https://api.example.com/data",
      auth: {:bearer, "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."})

    # Digest auth
    Req.get!("https://httpbin.org/digest-auth/auth/user/pass",
      auth: {:digest, "user:pass"})

    # Load from ~/.netrc
    Req.get!("https://api.example.com", auth: :netrc)
    Req.get!("https://api.example.com", auth: {:netrc, "/path/to/.netrc"})

    # Dynamic auth (fetched fresh per request):
    Req.get!("https://api.example.com",
      auth: fn -> {:bearer, MyApp.Auth.get_token()} end)

    # AWS SigV4 (S3, DynamoDB, etc.):
    s3 = Req.new(
      base_url: "https://my-bucket.s3.us-west-2.amazonaws.com",
      aws_sigv4: [
        access_key_id:     System.get_env("AWS_ACCESS_KEY_ID"),
        secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
        service:           :s3,
        region:            "us-west-2"
      ]
    )
    Req.put!(s3, url: "/my-key", body: "Hello, S3!")
    Req.get!(s3, url: "/my-key").body  #=> "Hello, S3!"
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Request bodies
  # -----------------------------------------------------------------------
  defp request_body do
    IO.puts("--- Request Body Encoding ---")

    IO.puts("""
    # JSON (sets Content-Type: application/json, encodes with Jason)
    Req.post!("https://httpbin.org/post", json: %{name: "Alice", age: 30})

    # URL-encoded form (sets Content-Type: application/x-www-form-urlencoded)
    Req.post!("https://httpbin.org/post", form: [name: "Alice", tag: "user"])

    # Multipart form (file upload)
    Req.post!("https://httpbin.org/post",
      form_multipart: [
        username: "alice",
        avatar: {File.read!("avatar.png"), filename: "avatar.png", content_type: "image/png"}
      ])

    # Multipart with streaming (no need to read whole file into memory)
    Req.post!("https://httpbin.org/post",
      form_multipart: [
        file: {File.stream!("large.bin"), filename: "large.bin"}
      ])

    # Raw body
    Req.post!("https://httpbin.org/post", body: "raw bytes here")

    # Compressed request body (gzip)
    Req.post!("https://httpbin.org/post",
      compress_body: true,
      json: %{large: "data"})

    # Compressed response (ask server for gzip, auto-decompress)
    Req.get!("https://httpbin.org/gzip", compressed: true)
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 6. Streaming responses
  # -----------------------------------------------------------------------
  defp streaming do
    IO.puts("--- Streaming Responses ---")

    IO.puts("""
    # Stream to a file (no memory overhead):
    Req.get!("https://speed.hetzner.de/10MB.bin",
      into: File.stream!("downloaded.bin"))

    # Stream to stdout:
    Req.get!("https://httpbin.org/stream/5", into: IO.stream())

    # Stream with a callback (process each chunk):
    Req.get!("https://httpbin.org/stream/3",
      into: fn {:data, chunk}, {req, resp} ->
        IO.write(chunk)
        {:cont, {req, resp}}
      end)

    # Async stream to current process mailbox:
    resp = Req.get!("https://httpbin.org/stream/3", into: :self)
    # resp.body is %Req.Response.Async{}

    # Read messages:
    msg = receive do message -> message end
    Req.parse_message(resp, msg)
    #=> {:ok, [data: "line1\\n"]}

    # Or use Enum (blocks until all chunks received):
    Enum.each(resp.body, fn chunk -> IO.write(chunk) end)

    # Cancel async stream:
    Req.cancel_async_response(resp)

    # Range requests (partial content):
    resp = Req.get!("https://httpbin.org/range/100", range: 0..3)
    resp.status  #=> 206 (Partial Content)
    resp.body    #=> "abcd"
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 7. Retry and error handling
  # -----------------------------------------------------------------------
  defp retry_and_errors do
    IO.puts("--- Retry & Error Handling ---")

    IO.puts("""
    # Default: retry safe methods (GET/HEAD) on transient HTTP errors
    # Retries on: 408, 429, 500, 502, 503, 504, and network errors
    # Max 3 retries total (4 requests)
    Req.get!("https://httpbin.org/status/500,200")

    # Retry all methods:
    Req.post!("https://api.example.com", json: %{}, retry: :transient)

    # Disable retries:
    Req.get!("https://api.example.com", retry: false)

    # Custom retry logic:
    Req.get!("https://api.example.com",
      retry: fn _req, response ->
        case response do
          %Req.Response{status: 429} -> {:delay, 5_000}  # wait 5s
          %Req.Response{status: 500} -> true              # retry with default delay
          _                          -> false             # don't retry
        end
      end)

    # Custom backoff strategy:
    Req.get!("https://example.com",
      retry_delay: fn attempt -> attempt * 1_000 end)  # 1s, 2s, 3s, ...

    # Max retries:
    Req.get!("https://example.com", max_retries: 5)

    # Raise on HTTP 4xx/5xx (default: return them as-is):
    Req.get!("https://httpbin.org/status/404", http_errors: :raise)
    #=> raises RuntimeError

    # Verify exact status:
    Req.get!("https://httpbin.org/status/200", expect: 200)
    Req.get!("https://httpbin.org/status/201", expect: 200..299)

    # Timeouts:
    Req.get!("https://example.com",
      connect_options: [timeout: 5_000],  # connection timeout
      receive_timeout: 30_000)             # read timeout

    # Checksum verification:
    Req.get!("https://httpbin.org/json",
      checksum: "sha256:abc123...")
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 8. Custom steps (plugin/middleware API)
  # -----------------------------------------------------------------------
  defp custom_steps do
    IO.puts("--- Custom Steps (Middleware) ---")

    IO.puts("""
    # Steps transform request or response. Compose them with Req.new/1.

    defmodule MyApp.ReqPlugins do
      # Attach a custom step to a request
      def attach(request) do
        request
        |> Req.Request.register_options([:log_requests])
        |> Req.Request.append_request_steps(log: &log_request/1)
        |> Req.Request.append_response_steps(log: &log_response/1)
      end

      # Request step: receives %Req.Request{}, returns %Req.Request{}
      defp log_request(request) do
        Logger.debug("→ \#{request.method |> to_string() |> String.upcase()} \#{request.url}")
        request
      end

      # Response step: receives {request, response}, returns {request, response}
      defp log_response({request, response}) do
        Logger.debug("← \#{response.status} \#{request.url}")
        {request, response}
      end
    end

    # Use it:
    req = Req.new(base_url: "https://api.example.com")
          |> MyApp.ReqPlugins.attach()

    Req.get!(req, url: "/users")

    # Halt the pipeline early (e.g. cache hit):
    defp cache_response(request) do
      case Cache.get(request.url) do
        nil  -> request
        body -> Req.Request.halt(request, %Req.Response{status: 200, body: body})
      end
    end
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 9. Testing with Plug adapter
  # -----------------------------------------------------------------------
  defp testing_with_plug do
    IO.puts("--- Testing with Plug (no real HTTP) ---")

    IO.puts("""
    # In tests, pass plug: instead of a URL.
    # No network needed — request goes through the Plug directly.

    # Using a Plug module:
    defmodule FakeAPI do
      use Plug.Router
      plug :match
      plug :dispatch

      get "/users" do
        send_resp(conn, 200, Jason.encode!([%{id: 1, name: "Alice"}]))
      end

      match _ do
        send_resp(conn, 404, "Not Found")
      end
    end

    resp = Req.get!(plug: FakeAPI, url: "/users")
    resp.status  #=> 200
    resp.body    #=> [%{"id" => 1, "name" => "Alice"}]

    # Using a function plug (simpler for one-off tests):
    json_plug = fn conn ->
      Req.Test.json(conn, %{message: "hello"})
    end
    resp = Req.get!(plug: json_plug)
    resp.body["message"]  #=> "hello"

    # Simulate transport errors:
    error_plug = fn conn ->
      Req.Test.transport_error(conn, :timeout)
    end
    {:error, %Req.TransportError{reason: :timeout}} =
      Req.get(plug: error_plug, retry: false)

    # Standard ExUnit test:
    defmodule MyClient.Test do
      use ExUnit.Case

      test "fetches users" do
        api = fn conn ->
          Req.Test.json(conn, [%{id: 1, name: "Alice"}])
        end

        assert Req.get!(plug: api).body == [%{"id" => 1, "name" => "Alice"}]
      end
    end
    """)
    IO.puts("")
  end
end
