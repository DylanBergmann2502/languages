-- garbage_collection.lua

-- Get initial memory usage
local initial_memory = collectgarbage("count")
print(string.format("Initial memory usage: %.2f KB", initial_memory))

-- Function to show current memory usage and change from initial
local function show_memory(label)
    local current = collectgarbage("count")
    local diff = current - initial_memory
    print(string.format("%s: %.2f KB (change: %+.2f KB)",
        label, current, diff))
end

-- Controlling garbage collection
print("\n-- Garbage Collection Control --")
print("Available GC modes:")
print("  - collect: Performs a full garbage collection cycle")
print("  - stop: Stops the garbage collector")
print("  - restart: Restarts the garbage collector")
print("  - step: Performs a single step of incremental collection")
print("  - setpause: Sets the pause between collection cycles")
print("  - setstepmul: Sets the step multiplier for incremental collection")

-- Create a lot of temporary objects
print("\n-- Creating temporary objects --")
local function create_temp_objects(count)
    local temp = {}
    for i = 1, count do
        temp[i] = string.rep("*", 100) -- 100-character strings
    end
    show_memory("After creating " .. count .. " objects")
    return temp
end

-- Create objects and let them be garbage collected
local temp = create_temp_objects(10000)
temp = nil                -- Remove reference so objects can be collected
collectgarbage("collect") -- Force garbage collection
show_memory("After setting to nil and collecting")

-- Weak tables demonstration
print("\n-- Weak Tables --")

-- Create a weak table (keys are weak)
local weak_keys = setmetatable({}, { __mode = "k" })
print("Created table with weak keys (__mode = 'k')")

-- Create a weak table (values are weak)
local weak_values = setmetatable({}, { __mode = "v" })
print("Created table with weak values (__mode = 'v')")

-- Create a weak table (both keys and values are weak)
local weak_keysvalues = setmetatable({}, { __mode = "kv" })
print("Created table with weak keys and values (__mode = 'kv')")

-- Create some objects to use as keys and values
local function test_weak_tables()
    -- These objects only exist inside this function
    local obj1 = { name = "object 1" }
    local obj2 = { name = "object 2" }
    local obj3 = { name = "object 3" }

    -- Store in regular table (strong references)
    local regular_table = {}
    regular_table[obj1] = "value for obj1"
    regular_table[obj2] = obj3

    -- Store in weak-keyed table
    weak_keys[obj1] = "value for obj1"
    weak_keys[obj2] = obj3

    -- Store in weak-valued table
    weak_values["key for obj1"] = obj1
    weak_values["key for obj3"] = obj3

    -- Store in table with both weak
    weak_keysvalues[obj1] = obj2
    weak_keysvalues[obj3] = "string value" -- string is not an object, won't be weak

    -- Count entries before GC
    print("\nBefore GC:")
    print("  Regular table: " .. count_entries(regular_table) .. " entries")
    print("  Weak keys table: " .. count_entries(weak_keys) .. " entries")
    print("  Weak values table: " .. count_entries(weak_values) .. " entries")
    print("  Weak keys+values table: " .. count_entries(weak_keysvalues) .. " entries")
end

-- Helper to count entries in a table
function count_entries(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

-- Run the weak table test
test_weak_tables()

-- Force garbage collection
collectgarbage("collect")

-- Check what's left in the tables
print("\nAfter GC:")
print("  Weak keys table: " .. count_entries(weak_keys) .. " entries")
print("  Weak values table: " .. count_entries(weak_values) .. " entries")
print("  Weak keys+values table: " .. count_entries(weak_keysvalues) .. " entries")

-- Demonstrating __gc metamethod (finalization)
print("\n-- Finalization with __gc --")

-- Create a metatable with __gc
local mt = {
    __gc = function(obj)
        print("Object is being garbage collected: " .. obj.name)
    end
}

-- Function to create objects with finalizers
local function create_finalizable_objects()
    -- These will be collected when the function exits
    local obj1 = setmetatable({ name = "Finalizable 1" }, mt)
    local obj2 = setmetatable({ name = "Finalizable 2" }, mt)

    -- Keep a local reference to ensure they're not collected prematurely
    return obj1, obj2
end

-- Create the objects
local f1, f2 = create_finalizable_objects()
print("Objects created with __gc metamethod")

-- Remove one reference
f1 = nil
collectgarbage("collect")
print("Collected after removing one reference")

-- Remove the other reference
f2 = nil
collectgarbage("collect")
print("Collected after removing all references")

-- Show memory at the end
show_memory("Final memory")

-- Demonstrate garbage collector tuning
print("\n-- Tuning the Garbage Collector --")

-- Get current settings
local pause = collectgarbage("setpause", 200)
local stepmul = collectgarbage("setstepmul", 200)

print(string.format("Original GC settings - pause: %d%%, stepmul: %d%%",
    pause, stepmul))
print("Changed to: pause=200%, stepmul=200%")
print("Higher pause means less frequent collections")
print("Higher stepmul means more aggressive collection when it happens")

-- Reset to original values
collectgarbage("setpause", pause)
collectgarbage("setstepmul", stepmul)
print("Reset to original values")
