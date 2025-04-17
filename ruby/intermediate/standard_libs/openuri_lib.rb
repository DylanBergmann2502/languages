# Ruby OpenURI Library
# OpenURI is a wrapper around net/http, net/https and net/ftp that makes these
# libraries easier to use, allowing you to treat remote resources like local files.

# Require the open-uri library
require "open-uri"

puts "# Basic Usage of OpenURI Library"
puts "==============================="

########################################################################
# Basic usage - Reading from a URL
# open-uri adds an open method to the Kernel module, which can open remote resources

# Simple example - Getting a web page
puts "\n# Fetching a web page"
puts "===================="

begin
  # URI.open is the preferred method since Ruby 2.7 (open is deprecated)
  webpage = URI.open("https://example.com")

  # The returned object acts like both a File and an IO object
  puts "Resource type: #{webpage.class}"

  # Read the first 300 characters of the webpage
  content = webpage.read(300)
  puts "First 300 chars of example.com:\n#{content}..."

  # Don't forget to close the resource
  webpage.close
rescue => e
  puts "Error: #{e.message}"
end

########################################################################
# Reading the entire content at once

puts "\n# Reading entire content"
puts "======================="

begin
  # You can read the entire content at once
  content = URI.open("https://example.com").read

  # Count lines, words, and characters
  lines = content.lines.count
  words = content.split.count
  chars = content.length

  puts "example.com has:"
  puts "- #{lines} lines"
  puts "- #{words} words"
  puts "- #{chars} characters"
rescue => e
  puts "Error: #{e.message}"
end

########################################################################
# Handling different content types

puts "\n# Handling different content types"
puts "==============================="

begin
  # OpenURI can handle different kinds of resources (HTML, JSON, images, etc.)
  json_url = "https://jsonplaceholder.typicode.com/todos/1"
  json_data = URI.open(json_url).read

  puts "JSON data:"
  puts json_data

  # Let's parse it properly
  require "json"
  parsed_data = JSON.parse(json_data)
  puts "\nParsed as Ruby Hash:"
  puts "- User ID: #{parsed_data["userId"]}"
  puts "- Title: #{parsed_data["title"]}"
  puts "- Completed: #{parsed_data["completed"]}"
rescue => e
  puts "Error: #{e.message}"
end

########################################################################
# Handling metadata and headers

puts "\n# Metadata and headers"
puts "====================="

begin
  # OpenURI provides metadata about the fetched resource
  resource = URI.open("https://example.com")

  # Access resource metadata
  puts "Resource metadata:"
  puts "- Content type: #{resource.content_type}"
  puts "- Content encoding: #{resource.content_encoding}"
  puts "- Last modified: #{resource.last_modified}"
  puts "- Status: #{resource.status}"

  # Access HTTP response headers
  puts "\nResponse headers:"
  resource.meta.each do |key, value|
    puts "- #{key}: #{value}"
  end

  resource.close
rescue => e
  puts "Error: #{e.message}"
end

########################################################################
# Setting request options

puts "\n# Setting request options"
puts "======================="

begin
  # You can set various options when opening a URL
  options = {
    # Set request headers
    "User-Agent" => "Ruby/#{RUBY_VERSION}",
    "Accept" => "text/html",

    # Set connection options
    :read_timeout => 10,
    :open_timeout => 5,

    # Set SSL options
    :ssl_verify_mode => OpenSSL::SSL::VERIFY_PEER,
  }

  resource = URI.open("https://example.com", options)
  puts "Request successful with custom options"

  # Display the User-Agent that was sent
  puts "Used User-Agent: #{resource.meta["user-agent"]}"

  resource.close
rescue => e
  puts "Error: #{e.message}"
end

########################################################################
# Handling redirects

puts "\n# Handling redirects"
puts "==================="

begin
  # OpenURI follows redirects by default (up to 10)
  # Let's try a URL that redirects
  redirected = URI.open("http://github.com")  # Redirects to https

  # You can see where you ended up
  puts "Redirected to: #{redirected.base_uri}"

  # You can limit the number of redirects
  options = { :redirect => false }  # Disable redirects

  # This will raise an error since redirects are disabled
  URI.open("http://github.com", options)
rescue OpenURI::HTTPRedirect => e
  puts "Redirect detected to: #{e.uri}"
rescue => e
  puts "Error: #{e.message}"
end

########################################################################
# Downloading files

puts "\n# Downloading files"
puts "=================="

begin
  # Create a temporary file to demonstrate downloading
  require "tempfile"
  downloaded_file = Tempfile.new(["openuri-example", ".txt"])

  # Download and save a file
  URI.open("https://example.com") do |remote_file|
    downloaded_file.write(remote_file.read)
  end

  # Rewind and read the first 100 characters
  downloaded_file.rewind
  puts "Downloaded content (first 100 chars):"
  puts downloaded_file.read(100) + "..."

  # Get file size
  downloaded_file.rewind
  file_size = downloaded_file.size
  puts "Downloaded file size: #{file_size} bytes"

  # Clean up
  downloaded_file.close
  downloaded_file.unlink
rescue => e
  puts "Error: #{e.message}"
end

########################################################################
# Handling HTTP authentication

puts "\n# HTTP authentication"
puts "===================="

begin
  # Handle HTTP Basic Auth
  auth_url = "https://httpbin.org/basic-auth/user/passwd"

  # Method 1: Include credentials in the URL
  url_with_auth = "https://user:passwd@httpbin.org/basic-auth/user/passwd"

  puts "Method 1: Auth in URL"
  response = URI.open(url_with_auth).read
  puts "Success! Response: #{response.strip}"

  # Method 2: Provide auth options
  auth_options = {
    :http_basic_authentication => ["user", "passwd"],
  }

  puts "\nMethod 2: Auth in options"
  response = URI.open(auth_url, auth_options).read
  puts "Success! Response: #{response.strip}"
rescue => e
  puts "Authentication failed: #{e.message}"
end

########################################################################
# Handling HTTP errors

puts "\n# Handling HTTP errors"
puts "====================="

begin
  # Try to access a non-existent resource
  URI.open("https://httpbin.org/status/404")
rescue OpenURI::HTTPError => e
  # OpenURI raises HTTPError for 4xx and 5xx status codes
  status_code = e.io.status[0]
  message = e.io.status[1]

  puts "HTTP Error: #{status_code} #{message}"

  # You can still access the response body
  puts "Response body:"
  puts e.io.read
end

########################################################################
# Practical example: Fetching and processing RSS feed

puts "\n# Practical example: Processing RSS feed"
puts "======================================"

begin
  require "rss"

  # Fetch an RSS feed
  rss_url = "https://www.ruby-lang.org/en/feeds/news.rss"
  rss_content = URI.open(rss_url).read

  # Parse the RSS feed
  feed = RSS::Parser.parse(rss_content, false)

  puts "Ruby News Feed: #{feed.channel.title}"
  puts "Last updated: #{feed.channel.lastBuildDate}"
  puts "\nLatest articles:"

  # Display the latest 3 articles
  feed.items[0..2].each_with_index do |item, index|
    puts "\n#{index + 1}. #{item.title}"
    puts "   Date: #{item.pubDate}"
    puts "   Link: #{item.link}"
  end
rescue => e
  puts "Error processing RSS feed: #{e.message}"
end

########################################################################
# Security considerations

puts "\n# Security considerations"
puts "========================"

puts "When using OpenURI, keep these security considerations in mind:"
puts "- Validate URLs to prevent server-side request forgery (SSRF)"
puts "- Be careful with user-provided URLs"
puts "- Consider timeouts for performance and security"
puts "- Watch memory usage when downloading large files"
puts "- Use SSL verification for HTTPS resources"

# Example of proper SSL verification
begin
  ssl_options = { :ssl_verify_mode => OpenSSL::SSL::VERIFY_PEER }
  URI.open("https://example.com", ssl_options)
  puts "\nSecure connection established with proper SSL verification"
rescue => e
  puts "SSL Error: #{e.message}"
end

########################################################################
# Alternatives to OpenURI

puts "\n# Alternatives to OpenURI"
puts "========================"

puts "For more advanced HTTP functionality, consider these alternatives:"
puts "- Net::HTTP for more control over HTTP requests"
puts "- HTTParty gem for a clean, easy-to-use API"
puts "- Faraday gem for flexible HTTP client with middleware support"
puts "- RestClient gem for REST API interactions"
