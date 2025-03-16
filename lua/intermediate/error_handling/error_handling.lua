-- error_handling.lua
-- Comprehensive error handling techniques in Lua

print("===== Lua Error Handling Techniques =====\n")

-- Part 1: The error() function
print("--- Part 1: Using the error() function ---")

-- Basic error throwing
local function validate_age(age)
    if type(age) ~= "number" then
        error("Age must be a number", 2) -- Level 2 means report the caller's line
    end

    if age < 0 or age > 150 then
        error("Age must be between 0 and 150", 2)
    end

    return true
end

-- Testing the validate_age function with pcall
print("Testing validate_age:")
local tests = { 42, "not a number", -5, 200 }

for i, test in ipairs(tests) do
    local success, result = pcall(validate_age, test)
    print(string.format("Test %d with value %s: %s",
        i,
        tostring(test),
        success and "Valid" or result))
end
print()

-- Part 2: Combining pcall, xpcall, and error
print("--- Part 2: Combining pcall, xpcall, and error ---")

-- Define an error handler for xpcall
local function error_handler(err)
    return {
        original_message = err,
        traceback = debug.traceback("", 2),
        timestamp = os.time()
    }
end

-- Function to process a record
local function process_record(record)
    if type(record) ~= "table" then
        error("Record must be a table")
    end

    if not record.id then
        error("Record must have an id field")
    end

    if not record.name then
        error("Record with id " .. record.id .. " must have a name field")
    end

    -- Process the record (just a simulation)
    return string.format("Processed record: ID=%d, Name=%s", record.id, record.name)
end

-- Function to process multiple records with error handling
local function process_records(records)
    local results = {
        successful = {},
        failed = {}
    }

    for i, record in ipairs(records) do
        local success, result = xpcall(function()
            return process_record(record)
        end, error_handler)

        if success then
            table.insert(results.successful, {
                index = i,
                result = result
            })
        else
            table.insert(results.failed, {
                index = i,
                error = result
            })
        end
    end

    return results
end

-- Test the record processing system
local test_records = {
    { id = 1,      name = "Alice" },
    "not a table",
    { name = "Bob" },
    { id = 3 },
    { id = 4,      name = "Charlie" }
}

local results = process_records(test_records)

print("Successful operations:")
for _, item in ipairs(results.successful) do
    print(string.format("  Record %d: %s", item.index, item.result))
end

print("\nFailed operations:")
for _, item in ipairs(results.failed) do
    print(string.format("  Record %d: %s",
        item.index,
        item.error.original_message))
end
print()

-- Part 3: Nested error handling and bubbling up errors
print("--- Part 3: Nested error handling and bubbling up errors ---")

-- A set of nested functions to demonstrate error bubbling
local function level3_func(x)
    if x <= 0 then
        error("Value must be positive")
    end
    return math.sqrt(x)
end

local function level2_func(x)
    -- Option 1: Let errors bubble up
    return level3_func(x)
end

local function level2_func_with_handling(x)
    -- Option 2: Handle errors and possibly re-throw
    local success, result = pcall(level3_func, x)
    if not success then
        error("Error in level3: " .. result, 2)
    end
    return result
end

local function level1_func(x, use_handling)
    if use_handling then
        return level2_func_with_handling(x)
    else
        return level2_func(x)
    end
end

-- Test both approaches
print("Testing error bubbling:")
local tests = { 4, -3 }

for _, test in ipairs(tests) do
    -- Test without intermediate handling
    local success, result = pcall(level1_func, test, false)
    print(string.format("Value %d without handling: %s",
        test,
        success and tostring(result) or result))

    -- Test with intermediate handling
    local success, result = pcall(level1_func, test, true)
    print(string.format("Value %d with handling: %s",
        test,
        success and tostring(result) or result))
end
print()

-- Part 4: Creating and using custom error types
print("--- Part 4: Custom error types ---")

-- Define custom error types
local ValidationError = {
    type = "ValidationError",
    __tostring = function(self)
        return string.format("[%s] %s", self.type, self.message)
    end
}

local DatabaseError = {
    type = "DatabaseError",
    __tostring = function(self)
        return string.format("[%s] %s", self.type, self.message)
    end
}

-- Functions to create error objects
local function new_validation_error(message)
    local err = setmetatable({ message = message }, { __index = ValidationError })
    return err
end

local function new_database_error(message, query)
    local err = setmetatable({
        message = message,
        query = query
    }, { __index = DatabaseError })
    return err
end

-- Function that throws custom errors
local function save_user(user)
    -- Validate first
    if type(user) ~= "table" then
        error(new_validation_error("User must be a table"))
    end

    if not user.name or #user.name < 3 then
        error(new_validation_error("User name must be at least 3 characters"))
    end

    -- Simulate DB operation
    if user.name == "admin" then
        error(new_database_error("Duplicate user found", "INSERT INTO users..."))
    end

    -- Success path
    return true, "User saved successfully"
end

-- Error checker helper
local function is_error_type(err, error_type)
    if type(err) == "table" and err.type then
        return err.type == error_type
    end
    return false
end

-- Test our custom error system
local test_users = {
    { name = "Bob" },
    123,               -- not a table
    { name = "Jo" },   -- too short
    { name = "admin" } -- trigger DB error
}

print("Testing custom error types:")
for i, user in ipairs(test_users) do
    local success, result = pcall(save_user, user)

    print(string.format("User %d: %s", i,
        type(user) == "table" and tostring(user.name or "unnamed") or tostring(user)))

    if success then
        print("  Success: " .. tostring(result)) -- Convert result to string
    else
        -- Check error type and handle appropriately
        if is_error_type(result, "ValidationError") then
            print("  Validation Error: " .. result.message)
        elseif is_error_type(result, "DatabaseError") then
            print("  Database Error: " .. result.message)
            print("  Failed Query: " .. result.query)
        else
            print("  Unknown Error: " .. tostring(result))
        end
    end
end
print()

-- Part 5: The assert function
print("--- Part 5: Using assert for error handling ---")

local function divide_numbers(a, b)
    -- Assert will error if the condition is false
    assert(type(a) == "number", "First argument must be a number")
    assert(type(b) == "number", "Second argument must be a number")
    assert(b ~= 0, "Cannot divide by zero")

    return a / b
end

print("Testing assert:")
local test_cases = {
    { 10,    2 },
    { "ten", 2 },
    { 10,    0 },
    { 20,    5 }
}

for i, test in ipairs(test_cases) do
    local a, b = test[1], test[2]
    local success, result = pcall(divide_numbers, a, b)

    print(string.format("Dividing %s by %s: %s",
        tostring(a),
        tostring(b),
        success and tostring(result) or result))
end

print("\n===== End of Error Handling Examples =====")
