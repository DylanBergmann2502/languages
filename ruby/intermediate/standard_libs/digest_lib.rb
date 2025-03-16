# Ruby Digest Library
# The Digest library provides a framework for message digest libraries

# Require the digest library
require 'digest'

puts "# Basic Usage of Digest Library"
puts "==============================="

########################################################################
# The Digest module supports multiple hashing algorithms
# Common ones include MD5, SHA1, SHA256, SHA384, and SHA512

# MD5 - Not secure for cryptographic purposes, but useful for checksums
md5 = Digest::MD5.hexdigest("hello world")
puts "MD5 of 'hello world': #{md5}"

# SHA1 - Also considered insecure for cryptographic purposes now
sha1 = Digest::SHA1.hexdigest("hello world")
puts "SHA1 of 'hello world': #{sha1}"

# SHA256 - More secure, commonly used
sha256 = Digest::SHA256.hexdigest("hello world")
puts "SHA256 of 'hello world': #{sha256}"

########################################################################
# Different ways to create digests

puts "\n# Different Ways to Create Digests"
puts "================================="

# Method 1: Direct hexdigest on a string
direct_hex = Digest::SHA256.hexdigest("hello")
puts "Direct hexdigest: #{direct_hex}"

# Method 2: Create new instance and update
digest = Digest::SHA256.new
digest.update("hello")
instance_hex = digest.hexdigest
puts "Instance update then hexdigest: #{instance_hex}"

# Method 3: Using << operator (same as update)
digest = Digest::SHA256.new
digest << "hello"
operator_hex = digest.hexdigest
puts "Using << operator: #{operator_hex}"

# All methods produce the same result
puts "All methods equal? #{direct_hex == instance_hex && instance_hex == operator_hex}"

########################################################################
# Incremental updates
# You can update the digest multiple times before generating the final hash

puts "\n# Incremental Updates"
puts "===================="

digest = Digest::SHA256.new
digest.update("hello")
digest.update(" ")
digest.update("world")
incremental = digest.hexdigest

# Same as doing it all at once
all_at_once = Digest::SHA256.hexdigest("hello world")

puts "Incremental updates: #{incremental}"
puts "All at once: #{all_at_once}"
puts "Are they equal? #{incremental == all_at_once}"

########################################################################
# Different output formats

puts "\n# Different Output Formats"
puts "========================="

digest = Digest::SHA256.new
digest.update("hello world")

# Hexdigest - returns the hash value as a hex string
hex = digest.hexdigest
puts "Hexdigest (string): #{hex}"

# Digest - returns the hash value as a binary string
binary = digest.digest
puts "Binary digest (showing first 8 bytes): #{binary[0..7].unpack('H*').first}"

# Base64 digest - needs additional conversion
require 'base64'
base64 = Base64.strict_encode64(digest.digest)
puts "Base64 digest: #{base64}"

########################################################################
# File digests - calculating hash of file contents

puts "\n# File Digests"
puts "============="

# Create a temporary file for demonstration
require 'tempfile'
temp_file = Tempfile.new('digest_demo')
temp_file.write("This is some test content for our digest example.")
temp_file.close

# Method 1: Read file content and calculate hash
file_content = File.read(temp_file.path)
content_hash = Digest::SHA256.hexdigest(file_content)
puts "Hash from file content: #{content_hash}"

# Method 2: Use the file method (more memory efficient for large files)
file_hash = Digest::SHA256.file(temp_file.path).hexdigest
puts "Hash using file method: #{file_hash}"

# They should be equal
puts "Are they equal? #{content_hash == file_hash}"

# Clean up the temporary file
temp_file.unlink

########################################################################
# Practical example: Verifying file integrity

puts "\n# Practical Example: Verifying File Integrity"
puts "==========================================="

# Create another temporary file
integrity_file = Tempfile.new('integrity_check')
integrity_file.write("Important data that should not be tampered with")
integrity_file.close

# Calculate original hash
original_hash = Digest::SHA256.file(integrity_file.path).hexdigest
puts "Original file hash: #{original_hash}"

# Simulate file verification
verified_hash = Digest::SHA256.file(integrity_file.path).hexdigest
is_verified = verified_hash == original_hash
puts "Verification result: #{is_verified ? 'File is intact' : 'File has been modified'}"

# Simulate file tampering
File.open(integrity_file.path, 'a') { |f| f.write("\nSomeone tampered with this file!") }

# Verify again after tampering
tampered_hash = Digest::SHA256.file(integrity_file.path).hexdigest
is_verified = tampered_hash == original_hash
puts "After tampering, verification result: #{is_verified ? 'File is intact' : 'File has been modified'}"
puts "Tampered file hash: #{tampered_hash}"

# Clean up
integrity_file.unlink

########################################################################
# Using different algorithms
# Note: Available algorithms may vary based on your Ruby installation and OS

puts "\n# Using Different Algorithms"
puts "=========================="

message = "The quick brown fox jumps over the lazy dog"

puts "MD5:    #{Digest::MD5.hexdigest(message)}"
puts "SHA1:   #{Digest::SHA1.hexdigest(message)}"
puts "SHA256: #{Digest::SHA256.hexdigest(message)}"
puts "SHA384: #{Digest::SHA384.hexdigest(message)}"
puts "SHA512: #{Digest::SHA512.hexdigest(message)}"

# Check what algorithms are available
puts "\nAvailable algorithms:"
algorithms = Digest.constants.select { |c| Digest.const_get(c).is_a?(Class) && Digest.const_get(c) < Digest::Instance }
puts algorithms.join(", ")

########################################################################
# Comparing digests securely (constant-time comparison)
# Important for security-sensitive applications to prevent timing attacks

puts "\n# Secure Digest Comparison"
puts "========================"

digest1 = Digest::SHA256.hexdigest("password123")
digest2 = Digest::SHA256.hexdigest("password123")
digest3 = Digest::SHA256.hexdigest("differentpassword")

# Using ==
puts "Regular comparison (==): #{digest1 == digest2}"

# Using secure compare
require 'openssl'
puts "Secure comparison (digest1 vs digest2): #{OpenSSL.secure_compare(digest1, digest2)}"
puts "Secure comparison (digest1 vs digest3): #{OpenSSL.secure_compare(digest1, digest3)}"

# Note: For Ruby >= 2.5, use ActiveSupport::SecurityUtils.secure_compare
# or the OpenSSL.secure_compare as shown above
