-- serialization.lua
-- Different approaches for serializing Lua tables to strings/files and back

-- Simple table to use in examples
local function create_test_table()
    return {
        name = "John Doe",
        age = 30,
        is_active = true,
        skills = { "Lua", "Python", "JavaScript" },
        address = {
            street = "123 Main St",
            city = "Anytown",
            zip = 12345
        },
        scores = { math = 95, science = 88, history = 75 },
        [1] = "First element",
        [{}] = "This key won't serialize properly with simple methods",
        [function() end] = "Neither will this function key"
    }
end

-- Simple utility to print a table for verification
local function print_table(t, indent)
    if type(t) ~= "table" then
        print(tostring(t))
        return
    end

    indent = indent or ""

    for k, v in pairs(t) do
        local key_str = tostring(k)
        if type(k) == "string" then
            key_str = '"' .. k .. '"'
        end

        if type(v) == "table" then
            print(indent .. key_str .. " = {")
            print_table(v, indent .. "    ")
            print(indent .. "}")
        else
            local val_str = tostring(v)
            if type(v) == "string" then
                val_str = '"' .. v .. '"'
            end
            print(indent .. key_str .. " = " .. val_str)
        end
    end
end

-- Basic serialization using string.format
-- Only works for simple tables with string/number keys
local function basic_serialize(o)
    local t = type(o)
    if t == "number" or t == "boolean" or t == "nil" then
        return tostring(o)
    elseif t == "string" then
        return string.format("%q", o)
    elseif t == "table" then
        local result = "{"
        for k, v in pairs(o) do
            -- Check key type
            local key
            if type(k) == "number" then
                key = "[" .. k .. "]"
            elseif type(k) == "string" then
                key = '["' .. k .. '"]'
            else
                -- Skip keys that aren't strings or numbers
                goto continue
            end

            -- Check value type and serialize recursively
            local value
            if type(v) == "table" then
                value = basic_serialize(v)
            elseif type(v) == "string" then
                value = string.format("%q", v)
            elseif type(v) == "number" or type(v) == "boolean" then
                value = tostring(v)
            else
                -- Skip values that can't be serialized
                goto continue
            end

            -- Add key-value pair to result
            if result ~= "{" then
                result = result .. ", "
            end
            result = result .. key .. " = " .. value

            ::continue::
        end
        return result .. "}"
    else
        error("Cannot serialize a " .. t)
    end
end

-- Demo of basic serialization
local function demo_basic_serialization()
    print("=== Basic Serialization ===")

    local test_table = create_test_table()
    print("Original table:")
    print_table(test_table)

    print("\nSerialized:")
    local serialized = basic_serialize(test_table)
    print(serialized)

    print("\nDeserialized:")
    local deserialize_func = load("return " .. serialized)
    local deserialized = deserialize_func()
    print_table(deserialized)

    print("\nNote: Keys that are tables or functions are lost in basic serialization")
end

-- Save a serialized table to a file
local function save_table_to_file(table_data, filename)
    local file = io.open(filename, "w")
    if not file then
        error("Could not open file for writing: " .. filename)
    end

    local serialized = basic_serialize(table_data)
    file:write(serialized)
    file:close()

    print("Table saved to " .. filename)
end

-- Load a table from a serialized file
local function load_table_from_file(filename)
    local file = io.open(filename, "r")
    if not file then
        error("Could not open file for reading: " .. filename)
    end

    local serialized = file:read("*all")
    file:close()

    local deserialize_func = load("return " .. serialized)
    return deserialize_func()
end

-- Demo of file serialization
local function demo_file_serialization()
    print("\n=== File Serialization ===")

    local test_table = {
        name = "Alice",
        age = 25,
        hobbies = { "reading", "hiking", "coding" }
    }

    local filename = "serialized_data.lua"

    -- Save table to file
    save_table_to_file(test_table, filename)

    -- Load table from file
    local loaded_table = load_table_from_file(filename)

    print("Loaded table:")
    print_table(loaded_table)

    -- Clean up
    os.remove(filename)
    print("Removed temporary file: " .. filename)
end

-- Advanced serialization with support for cycles and metatables
local function advanced_serialize(name, value, saved)
    saved = saved or {} -- Initial value

    -- Handle basic types
    local t = type(value)
    if t ~= "table" then
        if t == "string" then
            return string.format("%q", value)
        else
            return tostring(value)
        end
    elseif saved[value] then
        -- Handle cycles
        return saved[value]
    else
        -- Save table in saved tables
        saved[value] = name

        -- Start serializing the table
        local result = "{"
        -- Add non-array elements
        for k, v in pairs(value) do
            if type(k) ~= "number" or k < 1 or k > #value then
                -- Serialize key
                local key
                if type(k) == "string" and k:match("^[_%a][_%w]*$") then
                    -- Simple identifier
                    key = k
                else
                    -- Complex key needs brackets
                    key = "[" .. advanced_serialize(name .. "_k", k, saved) .. "]"
                end

                -- Serialize value
                local val = advanced_serialize(name .. "." .. tostring(k), v, saved)

                -- Add key-value pair
                if result ~= "{" then
                    result = result .. ", "
                end
                result = result .. key .. " = " .. val
            end
        end

        -- Add array elements
        for i = 1, #value do
            if result ~= "{" then
                result = result .. ", "
            end
            result = result .. advanced_serialize(name .. "[" .. i .. "]", value[i], saved)
        end

        -- Handle metatable if present and __serialize metamethod exists
        local mt = getmetatable(value)
        if mt and mt.__serialize then
            if result ~= "{" then
                result = result .. ", "
            end
            result = result .. "__metatable = " .. advanced_serialize(name .. ".__mt", mt.__serialize(), saved)
        end

        return result .. "}"
    end
end

-- Demo of advanced serialization
local function demo_advanced_serialization()
    print("\n=== Advanced Serialization ===")

    -- Create a table with cycle
    local t1 = { name = "Cycle Demo" }
    t1.self = t1 -- Create cycle

    print("Table with cycle:")
    print("t1 = {name=\"Cycle Demo\", self=<cycle>}")

    print("\nAdvanced serialized:")
    local serialized = "return " .. advanced_serialize("t1", t1)
    print(serialized)

    print("\nNote: Advanced serialization handles cycles by using variable names")
end

-- JSON serialization
local function demo_json_serialization()
    print("\n=== JSON Serialization ===")
    print("Note: Pure Lua doesn't have built-in JSON support.")
    print("You would typically use a library like 'dkjson', 'lua-cjson', or 'lunajson'.")

    -- Simple JSON encoder (very basic, doesn't handle all cases)
    local function encode_json(obj)
        local t = type(obj)
        if t == "nil" then
            return "null"
        elseif t == "boolean" then
            return obj and "true" or "false"
        elseif t == "number" then
            return tostring(obj)
        elseif t == "string" then
            return '"' .. obj:gsub('[%z\1-\31\\"]', function(c)
                local special = {
                    ['"'] = '\\"',
                    ['\\'] = '\\\\',
                    ['\b'] = '\\b',
                    ['\f'] = '\\f',
                    ['\n'] = '\\n',
                    ['\r'] = '\\r',
                    ['\t'] = '\\t'
                }
                return special[c] or string.format('\\u00%02x', c:byte())
            end) .. '"'
        elseif t == "table" then
            -- Check if it's an array or an object
            local is_array = true
            local n = 0
            for k, _ in pairs(obj) do
                if type(k) ~= "number" or k <= 0 or k ~= math.floor(k) then
                    is_array = false
                    break
                end
                n = n + 1
            end
            if is_array and n == #obj then
                -- It's an array
                local parts = {}
                for i = 1, #obj do
                    parts[i] = encode_json(obj[i])
                end
                return "[" .. table.concat(parts, ",") .. "]"
            else
                -- It's an object
                local parts = {}
                for k, v in pairs(obj) do
                    if type(k) == "string" then
                        parts[#parts + 1] = encode_json(k) .. ":" .. encode_json(v)
                    end
                end
                return "{" .. table.concat(parts, ",") .. "}"
            end
        else
            error("Cannot encode " .. t .. " to JSON")
        end
    end

    local test_data = {
        name = "Bob",
        age = 35,
        hobbies = { "gardening", "cooking" },
        address = {
            city = "Sometown",
            zip = 54321
        }
    }

    print("Original data:")
    print_table(test_data)

    print("\nJSON encoded:")
    local json_str = encode_json(test_data)
    print(json_str)

    print("\nNote: This is a very simple JSON encoder. For production use, use a proper library.")
end

-- Demo of serializing functions (limited capability)
local function demo_function_serialization()
    print("\n=== Function Serialization ===")
    print("Note: Lua has limited native support for function serialization.")

    -- Example function
    local function add(a, b)
        return a + b
    end

    -- Get function string (only works for simple functions defined in the source)
    local function get_function_source(f)
        if debug and debug.getinfo then
            local info = debug.getinfo(f, "S")
            if info and info.source and info.linedefined and info.lastlinedefined then
                -- If it's a file, try to read it
                if info.source:sub(1, 1) == "@" then
                    local filename = info.source:sub(2)
                    local file = io.open(filename, "r")
                    if file then
                        local lines = {}
                        local line_num = 1
                        for line in file:lines() do
                            if line_num >= info.linedefined and line_num <= info.lastlinedefined then
                                table.insert(lines, line)
                            end
                            line_num = line_num + 1
                        end
                        file:close()
                        return table.concat(lines, "\n")
                    end
                end
                return "-- Cannot retrieve source code"
            end
        end
        return "-- Function source not available"
    end

    print("Original function: function add(a, b) return a + b end")
    print("\nFunction source (using debug):")
    print(get_function_source(add))

    print("\nFunction bytecode (can be used with string.dump/load):")
    local bytecode = string.dump(add)
    print("Binary data, length: " .. #bytecode .. " bytes")

    print("\nReconstructed function from bytecode:")
    local reconstructed = load(bytecode)
    print("Result of reconstructed function call add(5, 3): " .. reconstructed(5, 3))

    print("\nNote: Function serialization with string.dump doesn't preserve upvalues by default")
    print("and is not portable across different Lua versions or platforms.")
end

-- Main function to run all demos
local function main()
    demo_basic_serialization()
    demo_file_serialization()
    demo_advanced_serialization()
    demo_json_serialization()
    demo_function_serialization()

    print("\nSerialization operations completed.")
end

-- Run the main function
main()
