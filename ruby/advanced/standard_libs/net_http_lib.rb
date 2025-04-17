# Ruby's Net::HTTP - HTTP client for making web requests
require "net/http"
require "uri"
require "json"

#################################################################
# Basic GET Request
# Net::HTTP provides methods for making HTTP requests

# Simple GET request
uri = URI("https://httpbin.org/get")
response = Net::HTTP.get_response(uri)

puts "Response code: #{response.code}"
puts "Response body (truncated):"
puts response.body[0..200] + "..." if response.body.length > 200

#################################################################
# Different HTTP Methods
# Making requests with different HTTP methods

# POST request with form data
uri = URI("https://httpbin.org/post")
response = Net::HTTP.post_form(uri, "name" => "Ruby", "language" => "awesome")
puts "\nPOST form response code: #{response.code}"

# Using Net::HTTP.start for more control
uri = URI("https://httpbin.org/delete")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = (uri.scheme == "https")

# DELETE request
request = Net::HTTP::Delete.new(uri.path)
response = http.request(request)
puts "DELETE response code: #{response.code}"

#################################################################
# Working with Headers
# Setting and reading HTTP headers

uri = URI("https://httpbin.org/headers")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = (uri.scheme == "https")

request = Net::HTTP::Get.new(uri.path)
request["User-Agent"] = "Ruby Net::HTTP Example"
request["Accept"] = "application/json"
request["X-Custom-Header"] = "Custom Value"

response = http.request(request)
puts "\nRequest with custom headers:"
puts response.body[0..200] + "..." if response.body.length > 200

# Reading response headers
puts "\nResponse headers:"
response.each_header do |name, value|
  puts "#{name}: #{value}"
end

#################################################################
# Request with JSON Body
# Sending JSON data in request body

uri = URI("https://httpbin.org/post")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = (uri.scheme == "https")

request = Net::HTTP::Post.new(uri.path)
request["Content-Type"] = "application/json"

# Build a JSON object to send
data = {
  id: 123,
  name: "Ruby Example",
  tags: ["web", "http", "client"],
}

request.body = data.to_json
response = http.request(request)

puts "\nJSON POST response:"
parsed_response = JSON.parse(response.body)
puts JSON.pretty_generate(parsed_response)[0..300] + "..." if parsed_response.to_s.length > 300

#################################################################
# Query Parameters
# Adding query parameters to your requests

base_uri = URI("https://httpbin.org/get")
params = { "search" => "ruby", "limit" => 10 }
uri = URI(base_uri)
uri.query = URI.encode_www_form(params)

response = Net::HTTP.get_response(uri)
puts "\nGET with query parameters:"
puts "URL: #{uri}"
puts response.body[0..200] + "..." if response.body.length > 200

#################################################################
# Handling Timeouts
# Setting timeouts to prevent hanging requests

uri = URI("https://httpbin.org/delay/1")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = (uri.scheme == "https")

# Set timeout values
http.open_timeout = 1  # seconds to wait for connection
http.read_timeout = 2  # seconds to wait for response

begin
  puts "\nMaking request with timeout..."
  response = http.get(uri.path)
  puts "Success! Response code: #{response.code}"
rescue Net::OpenTimeout
  puts "Connection timed out!"
rescue Net::ReadTimeout
  puts "Response timed out!"
end

#################################################################
# HTTP Authentication
# Basic and Digest authentication

# Basic Auth
uri = URI("https://httpbin.org/basic-auth/user/passwd")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = (uri.scheme == "https")

request = Net::HTTP::Get.new(uri.path)
request.basic_auth("user", "passwd")

puts "\nBasic authentication:"
response = http.request(request)
puts "Response code: #{response.code}"
puts "Response body: #{response.body}"

#################################################################
# Following Redirects
# Net::HTTP doesn't automatically follow redirects, so we need to implement it

def fetch_with_redirects(uri_str, limit = 10)
  raise ArgumentError, "Too many redirects" if limit == 0

  uri = URI(uri_str)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = (uri.scheme == "https")

  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)

  case response
  when Net::HTTPSuccess
    response
  when Net::HTTPRedirection
    puts "Redirected to: #{response["location"]}"
    fetch_with_redirects(response["location"], limit - 1)
  else
    response.error!
  end
end

puts "\nFollowing redirects:"
begin
  response = fetch_with_redirects("https://httpbin.org/redirect/2")
  puts "Final response code: #{response.code}"
  puts "Final response body (truncated):"
  puts response.body[0..100] + "..." if response.body.length > 100
rescue => e
  puts "Error: #{e.message}"
end

#################################################################
# Uploading Files
# How to upload files with Net::HTTP

# Create a temporary file for demonstration
File.open("example_upload.txt", "w") do |file|
  file.puts "This is a sample file for upload demonstration."
  file.puts "Created at: #{Time.now}"
end

uri = URI("https://httpbin.org/post")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = (uri.scheme == "https")

# Create a multipart request
request = Net::HTTP::Post.new(uri.path)
boundary = "RubyNetHTTPExample"
request["Content-Type"] = "multipart/form-data; boundary=#{boundary}"

# Build the multipart body
post_body = []
post_body << "--#{boundary}\r\n"
post_body << "Content-Disposition: form-data; name=\"description\"\r\n\r\n"
post_body << "File upload example using Ruby Net::HTTP\r\n"

# Add the file part
post_body << "--#{boundary}\r\n"
post_body << "Content-Disposition: form-data; name=\"file\"; filename=\"example_upload.txt\"\r\n"
post_body << "Content-Type: text/plain\r\n\r\n"
post_body << File.read("example_upload.txt")
post_body << "\r\n--#{boundary}--\r\n"

# Set the body and send the request
request.body = post_body.join
response = http.request(request)

puts "\nFile upload response:"
parsed_response = JSON.parse(response.body)
puts JSON.pretty_generate(parsed_response)[0..300] + "..." if parsed_response.to_s.length > 300

#################################################################
# HTTP Streaming
# Processing responses as they arrive for large responses

uri = URI("https://httpbin.org/bytes/8192")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = (uri.scheme == "https")

request = Net::HTTP::Get.new(uri.path)

puts "\nStreaming response:"
byte_count = 0

http.request(request) do |response|
  response.read_body do |chunk|
    byte_count += chunk.bytesize
    print "."
    # In a real application, you would process each chunk here
  end
end

puts "\nReceived #{byte_count} bytes"

#################################################################
# Persistent Connections
# Reusing HTTP connections for multiple requests

uri = URI("https://httpbin.org")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = (uri.scheme == "https")

puts "\nDemonstrating persistent connection:"
http.start do |persistent_http|
  # First request
  response1 = persistent_http.get("/get")
  puts "First request: #{response1.code}"

  # Second request using same connection
  response2 = persistent_http.get("/user-agent")
  puts "Second request: #{response2.code}"

  # Third request using same connection
  response3 = persistent_http.get("/headers")
  puts "Third request: #{response3.code}"
end

# Connection is automatically closed after the block

#################################################################
# Clean up temporary files
puts "\nCleaning up..."
if File.exist?("example_upload.txt")
  File.delete("example_upload.txt")
  puts "Deleted: example_upload.txt"
end

puts "Done!"
