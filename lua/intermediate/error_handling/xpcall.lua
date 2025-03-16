-- xpcall.lua
-- Enhanced error handling in Lua using xpcall

-- xpcall is like pcall but allows you to provide a custom error handler
-- The error handler runs when an error occurs, allowing for better debugging

-- A simple error handler function
local function error_handler(err)
    print("\n---- Error Handler Called ----")
    print("Original error: " .. tostring(err))

    -- Get the traceback (stack trace)
    local traceback = debug.traceback("", 2)
    print("Stack trace:" .. traceback)

    -- You can modify the error message if needed
    return "Processed error: " .. tostring(err)
end

-- Example 1: Basic xpcall usage
local function risky_function()
    print("About to cause an error...")
    error("Something went wrong!")
    return "This will never be returned"
end

print("Example 1:")
local success, result = xpcall(risky_function, error_handler)
print("Success:", success)     -- false
print("Result:", result)       -- modified error message
print()

-- Example 2: xpcall with arguments using a wrapper function
local function divide(a, b)
    if b == 0 then
        error("Division by zero attempted")
    end
    return a / b
end

print("Example 2:")
local success, result = xpcall(function()
    return divide(10, 0)
end, error_handler)
print("Success:", success)     -- false
print("Result:", result)       -- modified error message
print()

-- Example 3: xpcall with a successful function
local function safe_function()
    print("This function runs safely")
    return "Operation completed successfully", 42
end

print("Example 3:")
local success, result1, result2 = xpcall(safe_function, error_handler)
print("Success:", success)              -- true
print("Results:", result1, result2)     -- function's return values
print()

-- Example 4: Custom error handler with additional context
local function context_error_handler(err)
    -- Get info about where the error occurred
    local info = debug.getinfo(2, "Sl")
    local location = info.short_src .. ":" .. info.currentline

    -- Add timestamp
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")

    -- Format a detailed error message
    local detailed_error = string.format(
        "[%s] Error at %s: %s\n%s",
        timestamp,
        location,
        tostring(err),
        debug.traceback("", 2)
    )

    print("\n---- Detailed Error Information ----")
    print(detailed_error)

    -- Return simplified error for the caller
    return "Error occurred, check log for details"
end

-- A function with nested calls to show stack trace
local function level3()
    error("Error at the deepest level")
end

local function level2()
    level3()
end

local function level1()
    level2()
end

print("Example 4:")
local success, result = xpcall(level1, context_error_handler)
print("Success:", success)     -- false
print("Result:", result)       -- simplified error message
print()

-- Example 5: Handling errors in a broader context using xpcall
local function process_user_input(input)
    -- Simulate validating and processing user input
    if type(input) ~= "string" then
        error("Input must be a string")
    end

    local number = tonumber(input)
    if not number then
        error("Input must be convertible to a number")
    end

    if number < 0 then
        error("Number must be positive")
    end

    return math.sqrt(number)
end

-- Simulate a user interaction system
local function user_interaction_system()
    print("Example 5: User input processing")
    local inputs = { "16", "not_a_number", "-4", "25" }

    for i, input in ipairs(inputs) do
        print("\nProcessing input: " .. input)
        local success, result = xpcall(function()
            return process_user_input(input)
        end, error_handler)

        if success then
            print("Calculation result: " .. result)
        else
            print("Failed to process input: " .. input)
            print("Error message: " .. result)
            -- Here we could log the error, ask for new input, etc.
        end
    end
end

user_interaction_system()
