defmodule LearnReq do
  @moduledoc """
  Req v0.5 — modern HTTP client for Elixir.

  Built on Finch/Mint/NimblePool. Composes request/response as a pipeline
  of steps. Replaces HTTPoison as the ecosystem standard.

  dep: {:req, "~> 0.5"}
  """

  def run do
    IO.puts("\n=== Req: Modern HTTP Client ===\n")

    basic_requests()
    response_struct()
    base_url_pattern()
    request_bodies()
    streaming()
    retry_and_errors()
    testing_with_plug()
    custom_steps()
  end

  # -----------------------------------------------------------------------
  # 1. Basic requests — all methods, JSON auto-decode, query params
  # -----------------------------------------------------------------------
  defp basic_requests do
    IO.puts("--- Basic Requests ---")

    # GET — JSON is automatically decoded because Content-Type is application/json
    resp = Req.get!("https://httpbin.org/json")
    IO.puts("GET status: #{resp.status}")
    IO.puts("GET body (decoded map): #{inspect(resp.body["slideshow"]["title"])}")

    # Query params
    resp = Req.get!("https://httpbin.org/get", params: [page: 1, per_page: 5])
    IO.puts("Query params echoed back: #{inspect(resp.body["args"])}")

    # Non-! variant returns {:ok, resp} | {:error, exception}
    case Req.get("https://httpbin.org/status/200") do
      {:ok, resp}   -> IO.puts("Non-! ok: #{resp.status}")
      {:error, err} -> IO.puts("Non-! error: #{inspect(err)}")
    end

    # HEAD — no body
    resp = Req.head!("https://httpbin.org/get")
    IO.puts("HEAD status: #{resp.status}, body: #{inspect(resp.body)}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Req.Response struct fields
  # -----------------------------------------------------------------------
  defp response_struct do
    IO.puts("--- Req.Response Struct ---")

    resp = Req.get!("https://httpbin.org/get",
      headers: %{"x-my-header" => "hello"})

    IO.puts("status:  #{resp.status}")
    IO.puts("headers: #{inspect(Req.Response.get_header(resp, "content-type"))}")
    IO.puts("body keys: #{inspect(Map.keys(resp.body))}")
    IO.puts("assigns: #{inspect(resp.assigns)}")  # user-assigned metadata

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. Base URL pattern — reusable client struct
  # -----------------------------------------------------------------------
  defp base_url_pattern do
    IO.puts("--- Base URL Pattern ---")

    # Req.new/1 builds a reusable base request — options merge on each call
    base = Req.new(
      base_url: "https://httpbin.org",
      headers: %{"x-client" => "learn-req"}
    )

    r1 = Req.get!(base, url: "/get",  params: [q: "hello"])
    r2 = Req.get!(base, url: "/uuid")

    IO.puts("Base client r1 url: #{r1.body["url"]}")
    IO.puts("Base client r2 uuid: #{r2.body["uuid"]}")

    # Path params — template substitution in URLs
    resp = Req.get!("https://httpbin.org/status/:code",
      path_params: [code: 201])
    IO.puts("Path param result status: #{resp.status}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Request bodies — JSON, form, raw
  # -----------------------------------------------------------------------
  defp request_bodies do
    IO.puts("--- Request Bodies ---")

    # JSON body — sets Content-Type: application/json, encodes automatically
    resp = Req.post!("https://httpbin.org/post",
      json: %{name: "Alice", age: 30})
    IO.puts("JSON post echoed: #{inspect(resp.body["json"])}")

    # URL-encoded form
    resp = Req.post!("https://httpbin.org/post",
      form: [username: "alice", role: "admin"])
    IO.puts("Form post echoed: #{inspect(resp.body["form"])}")

    # Raw binary body
    resp = Req.post!("https://httpbin.org/post",
      body: "raw text",
      headers: %{"content-type" => "text/plain"})
    IO.puts("Raw body echoed: #{inspect(resp.body["data"])}")

    # PUT and PATCH
    resp = Req.put!("https://httpbin.org/put", json: %{updated: true})
    IO.puts("PUT status: #{resp.status}")

    resp = Req.patch!("https://httpbin.org/patch", json: %{field: "new"})
    IO.puts("PATCH status: #{resp.status}")

    # DELETE
    resp = Req.delete!("https://httpbin.org/delete")
    IO.puts("DELETE status: #{resp.status}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Streaming — into file, IO.stream, callback
  # -----------------------------------------------------------------------
  defp streaming do
    IO.puts("--- Streaming ---")

    # Stream to IO — each chunk written as it arrives, no buffering
    IO.write("Streaming 3 lines: ")
    Req.get!("https://httpbin.org/stream/3",
      into: fn {:data, chunk}, {req, resp} ->
        # chunk is raw binary; process line-by-line or buffer yourself
        _ = chunk
        {:cont, {req, resp}}
      end)
    IO.puts("done")

    # Stream to a file (common for large downloads)
    tmp = System.tmp_dir!() |> Path.join("req_test.json")
    Req.get!("https://httpbin.org/json", into: File.stream!(tmp))
    IO.puts("Streamed to file, size: #{File.stat!(tmp).size} bytes")
    File.rm!(tmp)

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 6. Retry and error handling
  # -----------------------------------------------------------------------
  defp retry_and_errors do
    IO.puts("--- Retry & Errors ---")

    # Req auto-retries GET on 408/429/5xx — let's see it handle a 500
    # httpbin /status/500,200 returns 500 first time, 200 second
    # (in practice httpbin always returns the listed code, so we just show config)
    resp = Req.get!("https://httpbin.org/status/200",
      retry: false)  # disable retry
    IO.puts("retry: false, status: #{resp.status}")

    # http_errors: :raise — raises on 4xx/5xx instead of returning response
    try do
      Req.get!("https://httpbin.org/status/404", http_errors: :raise, retry: false)
    rescue
      e -> IO.puts("http_errors: :raise caught: #{Exception.message(e)}")
    end

    # Timeouts
    case Req.get("https://httpbin.org/delay/1",
      receive_timeout: 2_000,
      retry: false) do
      {:ok, r}  -> IO.puts("Delayed response: #{r.status}")
      {:error, e} -> IO.puts("Timeout: #{inspect(e)}")
    end

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 7. Testing with Plug — no network needed
  # -----------------------------------------------------------------------
  defp testing_with_plug do
    IO.puts("--- Testing with Plug (no real HTTP) ---")

    # Function plug — simplest form for one-off tests
    json_plug = fn conn ->
      Req.Test.json(conn, %{message: "hello", items: [1, 2, 3]})
    end

    resp = Req.get!(plug: json_plug, url: "/anything")
    IO.puts("Plug response body: #{inspect(resp.body)}")
    IO.puts("Plug response status: #{resp.status}")

    # Simulate transport error
    error_plug = fn conn ->
      Req.Test.transport_error(conn, :timeout)
    end
    case Req.get(plug: error_plug, retry: false) do
      {:error, %Req.TransportError{reason: :timeout}} ->
        IO.puts("Transport error simulated: :timeout")
      other ->
        IO.puts("Other: #{inspect(other)}")
    end

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 8. Custom steps — middleware/plugin API
  # -----------------------------------------------------------------------
  defp custom_steps do
    IO.puts("--- Custom Steps (Middleware) ---")

    # Steps are functions attached to the request/response pipeline.
    # Request step:  receives %Req.Request{}, returns %Req.Request{}
    # Response step: receives {request, response}, returns {request, response}

    add_trace_id = fn request ->
      trace_id = :crypto.strong_rand_bytes(8) |> Base.encode16(case: :lower)
      Req.Request.put_header(request, "x-trace-id", trace_id)
    end

    log_response = fn {request, response} ->
      IO.puts("  [step] #{request.method |> to_string() |> String.upcase()} → #{response.status}")
      {request, response}
    end

    req =
      Req.new(base_url: "https://httpbin.org")
      |> Req.Request.append_request_steps(add_trace_id: add_trace_id)
      |> Req.Request.append_response_steps(log: log_response)

    resp = Req.get!(req, url: "/headers")
    IO.puts("x-trace-id sent: #{resp.body["headers"]["X-Trace-Id"]}")

    IO.puts("")
  end
end
