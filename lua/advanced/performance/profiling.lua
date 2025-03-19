-- profiling.lua
-- Performance profiling techniques in Lua

-- ===== Simple Time Profiling =====
print("=== Simple Time Profiling ===")

-- Basic function to measure execution time
local function measure_time(func, ...)
    local start = os.clock()
    local results = { func(...) }
    local elapsed = os.clock() - start
    return elapsed, table.unpack(results)
end

-- Example function to profile
local function calculate_sum(n)
    local sum = 0
    for i = 1, n do
        sum = sum + i
    end
    return sum
end

-- Profile with different input sizes
local sizes = { 100000, 1000000, 10000000 }
for _, size in ipairs(sizes) do
    local time, result = measure_time(calculate_sum, size)
    print(string.format("Sum of 1 to %d = %d (took %.6f seconds)", size, result, time))
end

-- ===== Function Call Counting =====
print("\n=== Function Call Counting ===")

-- Create a decorator-like function that counts calls
local function create_call_counter(func)
    local count = 0
    return function(...)
        count = count + 1
        local result = func(...)
        return result, count
    end
end

-- Example with a recursive fibonacci function
local function fibonacci(n)
    if n <= 1 then
        return n
    else
        return fibonacci(n - 1) + fibonacci(n - 2)
    end
end

-- Create a counted version (without actually counting recursive calls)
local counted_fib = create_call_counter(fibonacci)

-- Test with small values
for i = 1, 10 do
    local result, count = counted_fib(i)
    print(string.format("fibonacci(%d) = %d (function called %d times)", i, result, count))
end

-- ===== Memory Usage Profiling =====
print("\n=== Memory Usage Profiling ===")

-- Function to get current memory usage
local function get_memory_usage()
    return collectgarbage("count") * 1024 -- returns bytes
end

-- Function to measure memory usage of a function
local function measure_memory(func, ...)
    collectgarbage("collect") -- Force garbage collection before measuring
    local start_memory = get_memory_usage()
    local results = { func(...) }
    collectgarbage("collect") -- Force garbage collection after function completes
    local end_memory = get_memory_usage()
    local memory_used = end_memory - start_memory

    return memory_used, table.unpack(results)
end

-- Example: create a large table
local function create_large_table(size)
    local t = {}
    for i = 1, size do
        t[i] = string.rep("x", 10) -- 10-char string
    end
    return t
end

-- Measure memory usage for different table sizes
local table_sizes = { 10000, 100000, 1000000 }
for _, size in ipairs(table_sizes) do
    local memory, result = measure_memory(create_large_table, size)
    print(string.format("Table of size %d created (memory used: %.2f KB)",
        size, memory / 1024))
end

-- ===== Using the debug library for profiling =====
print("\n=== Debug Library Profiling ===")

-- A simple call tracer using debug hooks
local function trace_calls(max_lines)
    local line_count = 0
    local calls = {}

    debug.sethook(function(event)
        if event == "call" then
            local info = debug.getinfo(2, "nS")
            local func_name = info.name or "unknown"
            local source = info.short_src or "unknown"
            local line = info.linedefined or 0
            local key = string.format("%s:%s:%d", source, func_name, line)

            calls[key] = (calls[key] or 0) + 1

            line_count = line_count + 1
            if line_count >= max_lines then
                debug.sethook() -- Clear the hook when we hit the limit
            end
        end
    end, "c")

    return calls
end

-- A recursive function to profile
local function factorial(n)
    if n <= 1 then
        return 1
    else
        return n * factorial(n - 1)
    end
end

-- A function with multiple internal function calls
local function test_function()
    local sum = 0
    for i = 1, 10 do
        sum = sum + factorial(i)
    end
    return sum
end

-- Start the tracer and run the test function
local calls = trace_calls(1000)
test_function()
debug.sethook() -- Make sure we turn off the hook

-- Display the most frequently called functions
print("Top called functions:")
local sorted_calls = {}
for func, count in pairs(calls) do
    table.insert(sorted_calls, { func = func, count = count })
end

table.sort(sorted_calls, function(a, b) return a.count > b.count end)

for i = 1, math.min(5, #sorted_calls) do
    local info = sorted_calls[i]
    print(string.format("%d: %s (%d calls)", i, info.func, info.count))
end

-- ===== Creating a simple profiling module =====
print("\n=== Simple Profiling Module ===")

local profiler = {}

-- Track individual function timing
profiler.functions = {}

-- Start timing a function
function profiler.start(name)
    local func_data = profiler.functions[name] or {
        calls = 0,
        total_time = 0,
        min_time = math.huge,
        max_time = 0
    }

    func_data.calls = func_data.calls + 1
    func_data.start_time = os.clock()
    profiler.functions[name] = func_data
end

-- End timing a function
function profiler.stop(name)
    local func_data = profiler.functions[name]
    if not func_data or not func_data.start_time then
        error("Profiler: stop() called without matching start() for " .. name)
    end

    local elapsed = os.clock() - func_data.start_time
    func_data.total_time = func_data.total_time + elapsed
    func_data.min_time = math.min(func_data.min_time, elapsed)
    func_data.max_time = math.max(func_data.max_time, elapsed)
    func_data.start_time = nil
end

-- Get a report of all profiled functions
function profiler.report()
    local report = {}

    for name, data in pairs(profiler.functions) do
        table.insert(report, {
            name = name,
            calls = data.calls,
            total_time = data.total_time,
            average_time = data.total_time / data.calls,
            min_time = data.min_time,
            max_time = data.max_time
        })
    end

    table.sort(report, function(a, b) return a.total_time > b.total_time end)
    return report
end

-- Test our profiler
for i = 1, 3 do
    profiler.start("fibonacci")
    fibonacci(25)
    profiler.stop("fibonacci")

    profiler.start("factorial")
    factorial(100)
    profiler.stop("factorial")
end

-- Display profiling results
local report = profiler.report()
print("Profiling results:")
for _, func in ipairs(report) do
    print(string.format("Function: %s", func.name))
    print(string.format("  Calls: %d", func.calls))
    print(string.format("  Total Time: %.6f seconds", func.total_time))
    print(string.format("  Average Time: %.6f seconds", func.average_time))
    print(string.format("  Min/Max Time: %.6f / %.6f seconds", func.min_time, func.max_time))
end

print("\nNOTE: For real-world applications, consider using specialized profiling tools like:")
print("- LuaJIT's built-in profiler (if using LuaJIT)")
print("- luaprofiler (C-based profiler)")
print("- jit.p module (for LuaJIT)")
print("- ProFi.lua (pure Lua profiling library)")
