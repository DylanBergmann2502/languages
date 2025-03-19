-- memory_optimization.lua

-- Utility function to measure memory usage
local function memory_usage()
    return collectgarbage("count")
end

-- Utility function to display memory difference
local function show_memory_usage(label, before)
    local after = memory_usage()
    print(string.format("%s: %.2f KB (change: %+.2f KB)",
        label, after, after - before))
    return after
end

-- Print header
print("Lua Memory Optimization Techniques")
print("=================================")

-- Start measuring
local initial_memory = memory_usage()
print(string.format("Initial memory usage: %.2f KB", initial_memory))

-- 1. Table Preallocation
print("\n-- 1. Table Preallocation --")
print("When you know the size of a table in advance, preallocate it to avoid rehashing")

local mem_before = memory_usage()

-- Without preallocation
local t1 = {}
for i = 1, 10000 do
    t1[i] = i
end
local mem_after_t1 = show_memory_usage("Without preallocation", mem_before)

-- With preallocation
mem_before = memory_usage()
local t2 = table.create and table.create(10000) or {}     -- table.create is LuaJIT-specific
for i = 1, 10000 do
    t2[i] = i
end
show_memory_usage("With preallocation", mem_before)

-- Clear tables to free memory
t1, t2 = nil, nil
collectgarbage("collect")
mem_before = memory_usage()

-- 2. Table Reuse
print("\n-- 2. Table Reuse --")
print("Reuse tables instead of creating new ones, especially in hot paths")

-- Function that creates a new table on each call
local function create_point(x, y)
    return { x = x, y = y }
end

-- Function that reuses a table
local point_pool = {}
local function get_point(x, y)
    local point = table.remove(point_pool) or {}
    point.x = x
    point.y = y
    return point
end

local function release_point(point)
    point.x, point.y = nil, nil
    table.insert(point_pool, point)
end

-- Without reuse
mem_before = memory_usage()
local points1 = {}
for i = 1, 10000 do
    points1[i] = create_point(i, i)
end
show_memory_usage("Without table reuse", mem_before)

-- Free memory
points1 = nil
collectgarbage("collect")
mem_before = memory_usage()

-- With reuse
local points2 = {}
for i = 1, 10000 do
    points2[i] = get_point(i, i)
end
show_memory_usage("With table reuse", mem_before)

-- Release all points
for _, point in ipairs(points2) do
    release_point(point)
end
points2 = nil
collectgarbage("collect")
mem_before = memory_usage()

-- 3. String Interning
print("\n-- 3. String Internalization --")
print("Lua automatically interns strings, but be aware of string concatenation")

-- Creating many string copies
mem_before = memory_usage()
local strings1 = {}
for i = 1, 1000 do
    strings1[i] = "same string"
end
show_memory_usage("After storing 1000 copies of the same string", mem_before)

-- Expensive string concatenation
mem_before = memory_usage()
local long_string = ""
for i = 1, 1000 do
    long_string = long_string .. "a"
end
show_memory_usage("After 1000 string concatenations", mem_before)

-- Efficient string concatenation
mem_before = memory_usage()
local string_parts = {}
for i = 1, 1000 do
    string_parts[i] = "a"
end
local efficient_string = table.concat(string_parts)
show_memory_usage("After table.concat of 1000 parts", mem_before)

-- Free memory
strings1, long_string, string_parts, efficient_string = nil, nil, nil, nil
collectgarbage("collect")
mem_before = memory_usage()

-- 4. Local Variables vs Table Lookups
print("\n-- 4. Local Variables vs Table Lookups --")
print("Local variables are faster than table lookups")

local t = {
    value = 0,
    nested = {
        value = 0
    }
}

-- Using table lookups
local function increment_with_lookup(iterations)
    for i = 1, iterations do
        t.value = t.value + 1
        t.nested.value = t.nested.value + 1
    end
end

-- Using local variables
local function increment_with_locals(iterations)
    local t_value = t.value
    local nested_value = t.nested.value

    for i = 1, iterations do
        t_value = t_value + 1
        nested_value = nested_value + 1
    end

    t.value = t_value
    t.nested.value = nested_value
end

local start_time = os.clock()
increment_with_lookup(1000000)
print(string.format("Time with lookups: %.6f seconds", os.clock() - start_time))

t.value, t.nested.value = 0, 0     -- reset values

start_time = os.clock()
increment_with_locals(1000000)
print(string.format("Time with locals: %.6f seconds", os.clock() - start_time))

-- 5. Function Closures and Memory
print("\n-- 5. Function Closures and Memory --")
print("Closures capture upvalues which can lead to memory issues")

mem_before = memory_usage()

-- Function that returns closures with captured data
local function create_closures_with_data()
    local large_data = string.rep("*", 10000)     -- 10KB string

    return function() return #large_data end
end

-- Create many closures that capture the same data
local closures = {}
for i = 1, 100 do
    closures[i] = create_closures_with_data()
end

show_memory_usage("After creating 100 closures with large captured data", mem_before)

-- Better approach: share the data
mem_before = memory_usage()
local shared_data = string.rep("*", 10000)     -- 10KB string

local function create_efficient_closure()
    return function() return #shared_data end
end

local efficient_closures = {}
for i = 1, 100 do
    efficient_closures[i] = create_efficient_closure()
end

show_memory_usage("After creating 100 closures with shared data", mem_before)

-- Free memory
closures, efficient_closures, shared_data = nil, nil, nil
collectgarbage("collect")
mem_before = memory_usage()

-- 6. Weak Tables for Caching
print("\n-- 6. Weak Tables for Caching --")
print("Use weak tables to allow the garbage collector to free unused cache entries")

-- Create a memoization function using a weak table
local function create_memoizer(func)
    local cache = setmetatable({}, { __mode = "kv" })   -- both weak keys and values

    return function(arg)
        if cache[arg] == nil then
            cache[arg] = func(arg)
        end
        return cache[arg]
    end
end

-- Expensive computation to memoize
local function expensive_computation(n)
    local result = {
        value = n,
        data = string.rep("*", n * 100)     -- create some data proportional to n
    }
    return result
end

-- Create memoized version
local memoized = create_memoizer(expensive_computation)

-- Use the memoized function
mem_before = memory_usage()
for i = 1, 10 do
    local result = memoized(i)
    print(string.format("Result for %d has length %d", i, #result.data))
end
show_memory_usage("After memoizing 10 results", mem_before)

-- Reuse some cached results
for i = 5, 10 do
    local result = memoized(i)
end

-- Create some temporary objects that will be garbage collected
for i = 1, 5 do
    local temp = {}
    for j = 1, 10000 do
        temp[j] = j
    end
end

-- Force garbage collection
collectgarbage("collect")
show_memory_usage("After garbage collection (weak table allows GC)", mem_before)

-- 7. Control GC behavior
print("\n-- 7. Controlling Garbage Collection --")
print("Adjust GC parameters for your application's memory profile")

-- Get current values
local pause = collectgarbage("setpause")
local stepmul = collectgarbage("setstepmul")

print(string.format("Default GC parameters: pause=%d%%, stepmul=%d%%", pause, stepmul))

-- For memory-intensive applications, you might want less frequent but more thorough GC
collectgarbage("setpause", 200)       -- Less frequent collection (higher pause)
collectgarbage("setstepmul", 200)     -- More aggressive when collecting (higher stepmul)

print("Changed to: pause=200%, stepmul=200%")
print("This means less frequent but more thorough garbage collection")

-- For latency-sensitive applications, you might want more frequent but gentler GC
collectgarbage("setpause", 100)       -- More frequent collection
collectgarbage("setstepmul", 100)     -- Less aggressive when collecting

print("Changed to: pause=100%, stepmul=100%")
print("This means more frequent but gentler garbage collection")

-- Reset to original values
collectgarbage("setpause", pause)
collectgarbage("setstepmul", stepmul)

-- 8. Reducing table overhead with arrays
print("\n-- 8. Packed Arrays vs Hash Tables --")
print("Sequential integer keys are more memory efficient than hash tables")

mem_before = memory_usage()
local array = {}
for i = 1, 10000 do
    array[i] = i
end
show_memory_usage("Array with sequential keys", mem_before)

mem_before = memory_usage()
local hash_table = {}
for i = 1, 10000 do
    hash_table["key" .. i] = i
end
show_memory_usage("Hash table with string keys", mem_before)

-- Summary
print("\n-- Summary of Memory Optimization Techniques --")
print("1. Preallocate tables when size is known")
print("2. Reuse tables instead of creating new ones")
print("3. Be careful with string concatenation (use table.concat)")
print("4. Use local variables instead of table lookups in hot paths")
print("5. Be aware of closure memory capture")
print("6. Use weak tables for caches")
print("7. Tune garbage collector based on application needs")
print("8. Use sequential arrays when possible instead of hash tables")

-- Final memory usage
show_memory_usage("\nFinal memory usage", initial_memory)
