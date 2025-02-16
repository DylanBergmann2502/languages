print("=== String to Number Conversions ===")
local str_number = "42"
local str_float = "3.14"
local to_number = tonumber(str_number)
local to_float = tonumber(str_float)
print(string.format("'42' to number: %d", to_number))    -- 42
print(string.format("'3.14' to number: %.2f", to_float)) -- 3.14

-- Failed conversion returns nil
local invalid_number = tonumber("not a number")
print(string.format("Invalid number conversion: %s", tostring(invalid_number))) -- nil

print("\n=== Number to String Conversions ===")
local num = 42
local float = 3.14159
-- Different ways to convert numbers to strings
local using_tostring = tostring(num)
local using_format = string.format("%d", num)
local using_concat = num .. ""                              -- Lua automatically converts when concatenating

print("Using tostring: " .. using_tostring)                 -- 42
print("Using string.format: " .. using_format)              -- 42
print("Using concatenation: " .. using_concat)              -- 42
print("Float formatting: " .. string.format("%.2f", float)) -- 3.14

print("\n=== Boolean Conversions ===")
-- To string
print("Boolean to string: " .. tostring(true))  -- true
print("Boolean to string: " .. tostring(false)) -- false

-- To number (Lua doesn't have direct boolean to number conversion)
-- But we can use conditional expression
local bool_to_num = true and 1 or 0
print("Boolean to number: " .. bool_to_num) -- 1

print("\n=== Truthy and Falsy Values ===")
-- In Lua, only false and nil are falsy, everything else is truthy
print("nil is falsy: " .. tostring(not nil))          -- true
print("false is falsy: " .. tostring(not false))      -- true
print("0 is truthy: " .. tostring(not 0))             -- false
print("empty string is truthy: " .. tostring(not "")) -- false

print("\n=== Type Coercion in Operations ===")
-- String concatenation with numbers
local auto_convert = "Value: " .. 42
print(auto_convert) -- Value: 42

-- Arithmetic operations require explicit conversion
local success, result = pcall(function()
    return "42" + 1            -- This actually works in Lua!
end)
print("'42' + 1 = " .. result) -- 43

local failure, error = pcall(function()
    return "not a number" + 1 -- This will fail
end)
print("Error when adding to invalid number: " .. error)
