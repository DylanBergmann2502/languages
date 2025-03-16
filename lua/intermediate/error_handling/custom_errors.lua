-- custom_errors.lua
-- Advanced error handling in Lua: Creating and using custom error types

print("===== Custom Error Types in Lua =====\n")

-- Part 1: Creating basic custom error objects
print("--- Part 1: Basic custom error objects ---")

-- A simple function that creates custom errors
local function create_error(error_type, message, extra_info)
    return {
        type = error_type,
        message = message,
        extra_info = extra_info,
        timestamp = os.time()
    }
end

-- Example of using the custom error
local function validate_username(username)
    if type(username) ~= "string" then
        error(create_error(
            "TypeError",
            "Username must be a string",
            { provided_type = type(username) }
        ))
    end

    if #username < 3 then
        error(create_error(
            "ValidationError",
            "Username too short",
            { min_length = 3, actual_length = #username }
        ))
    end

    if #username > 20 then
        error(create_error(
            "ValidationError",
            "Username too long",
            { max_length = 20, actual_length = #username }
        ))
    end

    -- Check for valid characters (only letters, numbers, underscores)
    if not username:match("^[%w_]+$") then
        error(create_error(
            "ValidationError",
            "Username contains invalid characters",
            { pattern = "^[%w_]+$" }
        ))
    end

    return true
end

-- Test the validation function
local test_usernames = {
    123,                                        -- not a string
    "ab",                                       -- too short
    "way_too_long_username_that_exceeds_limit", -- too long
    "user@name",                                -- invalid characters
    "valid_username"                            -- valid
}

print("Testing username validation:")
for i, username in ipairs(test_usernames) do
    local success, result = pcall(validate_username, username)

    print(string.format("Test %d with username: %s",
        i,
        tostring(username)))

    if success then
        print("  Valid username")
    else
        if type(result) == "table" and result.type then
            print(string.format("  Error type: %s", result.type))
            print(string.format("  Message: %s", result.message))

            -- Print any extra info
            if result.extra_info then
                for k, v in pairs(result.extra_info) do
                    print(string.format("  %s: %s", k, tostring(v)))
                end
            end
        else
            print("  Unexpected error: " .. tostring(result))
        end
    end
    print()
end

-- Part 2: Using metatables to create more sophisticated error objects
print("--- Part 2: Error objects with metatables ---")

-- Create base error class
local BaseError = {
    __tostring = function(self)
        return string.format("[%s] %s", self.type, self.message)
    end,

    -- Add details method to show additional information
    details = function(self)
        local result = { string.format("Error: %s", tostring(self)) }

        if self.source then
            table.insert(result, string.format("Source: %s", self.source))
        end

        if self.traceback then
            table.insert(result, "Traceback:")
            table.insert(result, self.traceback)
        end

        return table.concat(result, "\n")
    end
}

-- Create specific error types
local TypeError = { type = "TypeError" }
local ValidationError = { type = "ValidationError" }
local DatabaseError = { type = "DatabaseError" }
local NetworkError = { type = "NetworkError" }

-- Set up inheritance from BaseError
setmetatable(TypeError, { __index = BaseError })
setmetatable(ValidationError, { __index = BaseError })
setmetatable(DatabaseError, { __index = BaseError })
setmetatable(NetworkError, { __index = BaseError })

-- Error factory functions
local function create_type_error(message, source, extra)
    local err = setmetatable({
        message = message,
        source = source,
        extra = extra or {},
        traceback = debug.traceback("", 2),
        timestamp = os.time()
    }, { __index = TypeError, __tostring = BaseError.__tostring })

    return err
end

local function create_validation_error(message, source, extra)
    local err = setmetatable({
        message = message,
        source = source,
        extra = extra or {},
        traceback = debug.traceback("", 2),
        timestamp = os.time()
    }, { __index = ValidationError, __tostring = BaseError.__tostring })

    return err
end

local function create_database_error(message, query, source, extra)
    local err = setmetatable({
        message = message,
        query = query,
        source = source,
        extra = extra or {},
        traceback = debug.traceback("", 2),
        timestamp = os.time()
    }, { __index = DatabaseError, __tostring = BaseError.__tostring })

    return err
end

local function create_network_error(message, url, status_code, source, extra)
    local err = setmetatable({
        message = message,
        url = url,
        status_code = status_code,
        source = source,
        extra = extra or {},
        traceback = debug.traceback("", 2),
        timestamp = os.time()
    }, { __index = NetworkError, __tostring = BaseError.__tostring })

    return err
end

-- Example: User registration system with custom errors
local function register_user(user_data)
    -- Check if user_data is a table
    if type(user_data) ~= "table" then
        error(create_type_error(
            "User data must be a table",
            "register_user",
            { provided_type = type(user_data) }
        ))
    end

    -- Validate required fields
    if not user_data.username then
        error(create_validation_error(
            "Username is required",
            "register_user.validate"
        ))
    end

    if not user_data.email then
        error(create_validation_error(
            "Email is required",
            "register_user.validate"
        ))
    end

    if not user_data.password then
        error(create_validation_error(
            "Password is required",
            "register_user.validate"
        ))
    end

    -- Validate username (same rules as before)
    if type(user_data.username) ~= "string" then
        error(create_type_error(
            "Username must be a string",
            "register_user.validate_username",
            { provided_type = type(user_data.username) }
        ))
    end

    if #user_data.username < 3 then
        error(create_validation_error(
            "Username too short",
            "register_user.validate_username",
            { min_length = 3, actual_length = #user_data.username }
        ))
    end

    -- Simulate database operation
    if user_data.username == "admin" then
        error(create_database_error(
            "Username already exists",
            "INSERT INTO users (username, email, password) VALUES (?, ?, ?)",
            "register_user.db_insert"
        ))
    end

    -- Simulate email verification
    if user_data.email == "invalid@example" then
        error(create_network_error(
            "Failed to send verification email",
            "https://mail-api.example.com/send",
            500,
            "register_user.send_verification"
        ))
    end

    -- If all checks pass, return success
    return {
        success = true,
        user_id = math.random(1000, 9999),
        message = "User registered successfully"
    }
end

-- Helper function to check the type of an error
local function is_error_of_type(err, error_type)
    return type(err) == "table" and err.type == error_type
end

-- Test the user registration system
local test_users = {
    "not a table",
    {},                                                                             -- missing all fields
    { username = "admin",     email = "admin@example.com", password = "password123" }, -- existing username
    { username = "newuser",   email = "invalid@example",   password = "password123" }, -- email sending fails
    { username = "x",         email = "short@example.com", password = "password123" }, -- username too short
    { username = "validuser", email = "valid@example.com", password = "password123" } -- valid user
}

print("Testing user registration:")
for i, user_data in ipairs(test_users) do
    print(string.format("Test %d:", i))

    if type(user_data) == "table" then
        print(string.format("  User: %s",
            user_data.username and user_data.username or "undefined"))
    else
        print(string.format("  User data type: %s", type(user_data)))
    end

    local success, result = pcall(register_user, user_data)

    if success then
        print(string.format("  Success: User ID %d - %s",
            result.user_id,
            result.message))
    else
        -- Handle different error types
        if is_error_of_type(result, "TypeError") then
            print("  Type Error: " .. result.message)
            if result.extra and result.extra.provided_type then
                print(string.format("  Provided type: %s", result.extra.provided_type))
            end
        elseif is_error_of_type(result, "ValidationError") then
            print("  Validation Error: " .. result.message)
            print("  Source: " .. (result.source or "unknown"))
        elseif is_error_of_type(result, "DatabaseError") then
            print("  Database Error: " .. result.message)
            if result.query then
                print("  Failed query: " .. result.query)
            end
        elseif is_error_of_type(result, "NetworkError") then
            print("  Network Error: " .. result.message)
            if result.url then
                print("  URL: " .. result.url)
            end
            if result.status_code then
                print("  Status code: " .. result.status_code)
            end
        else
            print("  Unknown error: " .. tostring(result))
        end

        -- Uncomment to see full error details with traceback
        -- print("\n" .. result:details())
    end
    print()
end

-- Part 3: Error hierarchies and standard pattern for error handling
print("--- Part 3: Error hierarchies and handling patterns ---")

-- Create a complete function that handles errors in a standard way
local function try_catch(try_func, catch_func, finally_func)
    local status, result = pcall(try_func)

    if not status then
        -- Call the catch function with the error
        if catch_func then
            catch_func(result)
        end
    end

    -- Call the finally function if provided
    if finally_func then
        finally_func(status, result)
    end

    return status, result
end

-- Example: Processing multiple records with error handling
local function process_data(records)
    local processed = {}
    local failed = {}

    for i, record in ipairs(records) do
        try_catch(
        -- Try block
            function()
                print("Processing record " .. i)

                -- Simulate different error conditions
                if type(record) ~= "table" then
                    error(create_type_error(
                        "Record must be a table",
                        "process_data.validate"
                    ))
                end

                if not record.id then
                    error(create_validation_error(
                        "Record missing ID",
                        "process_data.validate"
                    ))
                end

                -- Simulated processing logic
                local processed_record = {
                    id = record.id,
                    status = "processed",
                    timestamp = os.time()
                }

                table.insert(processed, processed_record)
                print("  Success: Record " .. record.id .. " processed")
            end,

            -- Catch block
            function(err)
                local error_info = {
                    record_index = i,
                    record = record,
                    error = err
                }

                table.insert(failed, error_info)

                -- Log the error
                print("  Error processing record " .. i .. ": " .. tostring(err))
            end,

            -- Finally block (optional)
            function(status)
                print("  Finished processing record " .. i .. "\n")
            end
        )
    end

    return {
        processed = processed,
        failed = failed,
        total = #records,
        success_count = #processed,
        failure_count = #failed
    }
end

-- Test data
local test_records = {
    "not a table",
    { name = "Missing ID" },
    { id = 1,             name = "Valid Record" },
    { id = 2,             name = "Another Valid Record" },
    { id = 3 }
}

-- Process the records
print("Processing multiple records:")
local result = process_data(test_records)

-- Summary
print("\nProcessing Summary:")
print(string.format("Total records: %d", result.total))
print(string.format("Successfully processed: %d", result.success_count))
print(string.format("Failed: %d", result.failure_count))

print("\n===== End of Custom Error Examples =====")
