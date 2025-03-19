-- weak_tables.lua

print("Weak Tables in Lua")
print("==================")

-- Simple function to print the count of items in a table
local function count_items(t, name)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    print(string.format("%s contains %d items", name, count))
end

-- Simple function to display memory usage
local function show_memory()
    local mem = collectgarbage("count")
    print(string.format("Current memory usage: %.2f KB", mem))
end

print("\n-- Regular Tables vs Weak Tables --")
print("Regular tables hold strong references to their keys and values.")
print("Weak tables allow the garbage collector to collect keys or values")
print("that are not referenced elsewhere in the program.")

print("\nTypes of weak tables:")
print("  - Weak keys (__mode = 'k'): Keys can be collected if not referenced elsewhere")
print("  - Weak values (__mode = 'v'): Values can be collected if not referenced elsewhere")
print("  - Weak keys and values (__mode = 'kv'): Both keys and values can be collected")

-- Create different types of tables for demonstration
print("\nCreating tables for testing:")
local regular_table = {}
local weak_key_table = setmetatable({}, { __mode = "k" })
local weak_value_table = setmetatable({}, { __mode = "v" })
local weak_both_table = setmetatable({}, { __mode = "kv" })

print("  - Created regular table (strong references)")
print("  - Created weak-key table (__mode = 'k')")
print("  - Created weak-value table (__mode = 'v')")
print("  - Created weak-key-value table (__mode = 'kv')")

-- Function to demonstrate weak table behavior
local function demonstrate_weak_tables()
    print("\n-- Experiment 1: Objects as Keys --")

    -- Create objects to use as keys
    local key1 = { name = "key1" }
    local key2 = { name = "key2" }

    -- Store in different tables
    regular_table[key1] = "value1"
    weak_key_table[key2] = "value2"

    -- Check tables before garbage collection
    print("\nBefore garbage collection:")
    count_items(regular_table, "Regular table")
    count_items(weak_key_table, "Weak-key table")

    -- Remove external references to the keys
    print("\nRemoving references to keys...")
    key1 = nil
    key2 = nil

    -- Force garbage collection
    collectgarbage("collect")

    -- Check tables after garbage collection
    print("\nAfter garbage collection:")
    count_items(regular_table, "Regular table")
    count_items(weak_key_table, "Weak-key table")

    print("\n-- Experiment 2: Objects as Values --")

    -- Create objects to use as values
    local val1 = { name = "value1" }
    local val2 = { name = "value2" }

    -- Store in different tables
    regular_table["key1"] = val1
    weak_value_table["key2"] = val2

    -- Check tables before garbage collection
    print("\nBefore garbage collection:")
    count_items(regular_table, "Regular table")
    count_items(weak_value_table, "Weak-value table")

    -- Remove external references to the values
    print("\nRemoving references to values...")
    val1 = nil
    val2 = nil

    -- Force garbage collection
    collectgarbage("collect")

    -- Check tables after garbage collection
    print("\nAfter garbage collection:")
    count_items(regular_table, "Regular table")
    count_items(weak_value_table, "Weak-value table")

    print("\n-- Experiment 3: Objects as Both Keys and Values --")

    -- Create objects for both keys and values
    local obj1 = { name = "object1" }
    local obj2 = { name = "object2" }
    local obj3 = { name = "object3" }

    -- Store in different ways
    weak_both_table[obj1] = "string value" -- object key, string value
    weak_both_table["string key"] = obj2   -- string key, object value
    weak_both_table[obj3] = obj3           -- same object as key and value

    -- Check table before garbage collection
    print("\nBefore garbage collection:")
    count_items(weak_both_table, "Weak-both table")

    -- Remove references selectively
    print("\nRemoving reference to obj1 (used as a key)...")
    obj1 = nil
    collectgarbage("collect")
    count_items(weak_both_table, "Weak-both table")

    print("\nRemoving reference to obj2 (used as a value)...")
    obj2 = nil
    collectgarbage("collect")
    count_items(weak_both_table, "Weak-both table")

    print("\nRemoving reference to obj3 (used as both key and value)...")
    obj3 = nil
    collectgarbage("collect")
    count_items(weak_both_table, "Weak-both table")

    print("\n-- Experiment 4: Memory Management --")

    -- Create a function that generates a lot of tables
    local function create_many_tables(count, use_weak)
        local result = use_weak and
            setmetatable({}, { __mode = "v" }) or {}

        for i = 1, count do
            result[i] = {
                data = string.rep("*", 1000), -- 1KB string
                id = i
            }
        end

        return result
    end

    -- Check memory before
    print("\nBefore creating tables:")
    show_memory()

    -- Create a lot of tables with regular references
    print("\nCreating 10,000 tables with regular references...")
    local heavy_regular = create_many_tables(10000, false)
    count_items(heavy_regular, "Heavy regular table")
    show_memory()

    -- Set to nil and collect
    heavy_regular = nil
    collectgarbage("collect")
    print("\nAfter clearing regular table reference:")
    show_memory()

    -- Create a lot of tables with weak references
    print("\nCreating 10,000 tables with weak references...")
    local heavy_weak = create_many_tables(10000, true)
    count_items(heavy_weak, "Heavy weak table")
    show_memory()

    -- Create external references to prevent collection
    local external_refs = {}
    for i = 1, 10000 do
        if i <= 5000 then
            external_refs[i] = heavy_weak[i]
        end
    end

    -- Force collection
    collectgarbage("collect")
    print("\nAfter garbage collection (with 5000 external references):")
    count_items(heavy_weak, "Heavy weak table")
    show_memory()

    -- Remove all external references
    external_refs = nil
    collectgarbage("collect")
    print("\nAfter removing all external references:")
    count_items(heavy_weak, "Heavy weak table")
    show_memory()
end

-- Run the demonstration
demonstrate_weak_tables()

print("\n-- Important Notes About Weak Tables --")
print("1. Only object references (tables, userdata, functions, threads) can be weak")
print("2. Primitive values (numbers, strings, booleans) are always strong")
print("3. Weak tables are useful for:")
print("   - Implementing caches with automatic cleanup")
print("   - Building object pools")
print("   - Managing parent-child relationships without memory leaks")
print("   - Implementing observer patterns")
print("4. Weak references only affect garbage collection, not normal table operations")
