-- pcall.lua
-- Basic error handling in Lua using pcall (protected call)

-- pcall runs a function in protected mode, catching any errors
-- It returns true and the function results if successful
-- Or false and the error message if it fails

-- Example 1: Basic pcall with a function that works correctly
local function safe_division(a, b)
    return a / b
end

local success, result = pcall(safe_division, 10, 2)
print("Example 1:")
print("Success:", success)     -- true
print("Result:", result)       -- 5
print()

-- Example 2: pcall with a function that causes an error
local success, error_msg = pcall(safe_division, 10, 0)
print("Example 2:")
print("Success:", success)     -- false
print("Error:", error_msg)     -- division by zero error
print()

-- Example 3: Using anonymous functions with pcall
print("Example 3:")
local success, result = pcall(function()
    local x = 10
    local y = 5
    return x * y
end)
print("Success:", success)     -- true
print("Result:", result)       -- 50
print()

-- Example 4: Handling errors in larger operations
local function process_data(data)
    if type(data) ~= "table" then
        error("Expected a table, got " .. type(data))
    end

    local sum = 0
    for _, value in ipairs(data) do
        if type(value) ~= "number" then
            error("All values must be numbers")
        end
        sum = sum + value
    end

    return sum
end

-- Successful case
print("Example 4a:")
local data = { 1, 2, 3, 4, 5 }
local success, result = pcall(process_data, data)
print("Success:", success)     -- true
print("Sum:", result)          -- 15
print()

-- Error case
print("Example 4b:")
local bad_data = { 1, 2, "not a number", 4, 5 }
local success, error_msg = pcall(process_data, bad_data)
print("Success:", success)     -- false
print("Error:", error_msg)     -- error message about values being numbers
print()

-- Example 5: Nested pcall
print("Example 5:")
local success, result = pcall(function()
    print("Outer function started")

    local inner_success, inner_result = pcall(function()
        print("Inner function will error")
        error("Inner function error")
        return "This will never be returned"
    end)

    print("Inner pcall result:", inner_success, inner_result)

    if not inner_success then
        print("Handling the inner error and continuing")
    end

    return "Outer function completed"
end)

print("Outer pcall result:", success, result)
