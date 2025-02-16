-- Basic Types in Lua
print("=== Numbers ===")
local integer = 42
local float = 3.14
local scientific = 1.2e3
print(string.format("Integer: %d", integer))         -- 42
print(string.format("Float: %.2f", float))           -- 3.14
print(string.format("Scientific: %.1f", scientific)) -- 1200.0

print("\n=== Strings ===")
local single_quote = 'Hello'
local double_quote = "World"
local multiline = [[
This is a
multiline string]]
print(single_quote .. " " .. double_quote) -- Hello World
print(multiline)

print("\n=== Booleans ===")
local is_true = true
local is_false = false
print(string.format("true value: %s", tostring(is_true)))   -- true value: true
print(string.format("false value: %s", tostring(is_false))) -- false value: false

print("\n=== Nil ===")
local undefined_variable = nil
print(string.format("nil value: %s", tostring(undefined_variable))) -- nil value: nil

print("\n=== Type Checking ===")
print(string.format("Type of 42: %s", type(integer)))             -- number
print(string.format("Type of 'Hello': %s", type(single_quote)))   -- string
print(string.format("Type of true: %s", type(is_true)))           -- boolean
print(string.format("Type of nil: %s", type(undefined_variable))) -- nil
