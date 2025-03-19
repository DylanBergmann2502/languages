-- optimization_techniques.lua
-- Common performance optimization techniques for Lua

print("=== Lua Optimization Techniques ===")

-- ========== Table Optimizations ==========
print("\n--- Table Optimizations ---")

-- Pre-allocate tables when size is known
local function test_table_preallocation()
    print("Testing table preallocation:")

    local start_time = os.clock()
    local t1 = {}
    for i = 1, 1000000 do
        t1[i] = i
    end
    local regular_time = os.clock() - start_time

    start_time = os.clock()
    local t2 = table.create and table.create(1000000) or {} -- table.create is in LuaJIT/some Lua implementations
    for i = 1, 1000000 do
        t2[i] = i
    end
    local preallocated_time = os.clock() - start_time

    print(string.format("  Regular table: %.6f seconds", regular_time))
    print(string.format("  Pre-allocated: %.6f seconds", preallocated_time))
    print(string.format("  Improvement: %.2f%%", (1 - preallocated_time / regular_time) * 100))

    -- Note: If table.create is not available in your Lua version,
    -- the difference might not be noticeable in this test
end

test_table_preallocation()

-- Local variable access vs table access
local function test_local_vs_table()
    print("\nTesting local variables vs table lookups:")

    local t = { x = 0 }

    local start_time = os.clock()
    for i = 1, 10000000 do
        t.x = t.x + 1
    end
    local table_time = os.clock() - start_time

    start_time = os.clock()
    local x = 0
    for i = 1, 10000000 do
        x = x + 1
    end
    local local_time = os.clock() - start_time

    print(string.format("  Table access: %.6f seconds", table_time))
    print(string.format("  Local variable: %.6f seconds", local_time))
    print(string.format("  Improvement: %.2f%%", (1 - local_time / table_time) * 100))
end

test_local_vs_table()

-- ========== Loop Optimizations ==========
print("\n--- Loop Optimizations ---")

-- Caching length for ipairs/for loops
local function test_length_caching()
    print("Testing length caching in loops:")

    local t = {}
    for i = 1, 1000000 do
        t[i] = i
    end

    local start_time = os.clock()
    local sum1 = 0
    for i = 1, #t do -- Length calculated each iteration
        sum1 = sum1 + t[i]
    end
    local uncached_time = os.clock() - start_time

    start_time = os.clock()
    local sum2 = 0
    local length = #t -- Cached length
    for i = 1, length do
        sum2 = sum2 + t[i]
    end
    local cached_time = os.clock() - start_time

    print(string.format("  Uncached length: %.6f seconds", uncached_time))
    print(string.format("  Cached length: %.6f seconds", cached_time))
    print(string.format("  Improvement: %.2f%%", (1 - cached_time / uncached_time) * 100))
end

test_length_caching()

-- Numeric for vs ipairs
local function test_numeric_for_vs_ipairs()
    print("\nTesting numeric for vs ipairs:")

    local t = {}
    for i = 1, 1000000 do
        t[i] = i
    end

    local start_time = os.clock()
    local sum1 = 0
    for _, v in ipairs(t) do
        sum1 = sum1 + v
    end
    local ipairs_time = os.clock() - start_time

    start_time = os.clock()
    local sum2 = 0
    for i = 1, #t do
        sum2 = sum2 + t[i]
    end
    local numeric_for_time = os.clock() - start_time

    print(string.format("  ipairs: %.6f seconds", ipairs_time))
    print(string.format("  numeric for: %.6f seconds", numeric_for_time))
    print(string.format("  Improvement: %.2f%%", (1 - numeric_for_time / ipairs_time) * 100))
end

test_numeric_for_vs_ipairs()

-- ========== Function Optimizations ==========
print("\n--- Function Optimizations ---")

-- Upvalues vs global lookups
local function test_upvalues()
    print("Testing upvalues vs global lookups:")

    -- Using global math.sin
    local start_time = os.clock()
    local sum1 = 0
    for i = 1, 1000000 do
        sum1 = sum1 + math.sin(i * 0.001)
    end
    local global_time = os.clock() - start_time

    -- Using upvalue for math.sin
    local sin = math.sin
    start_time = os.clock()
    local sum2 = 0
    for i = 1, 1000000 do
        sum2 = sum2 + sin(i * 0.001)
    end
    local upvalue_time = os.clock() - start_time

    print(string.format("  Global lookup: %.6f seconds", global_time))
    print(string.format("  Upvalue: %.6f seconds", upvalue_time))
    print(string.format("  Improvement: %.2f%%", (1 - upvalue_time / global_time) * 100))
end

test_upvalues()

-- Function calls vs inline operations
local function test_function_calls()
    print("\nTesting function calls vs inline operations:")

    local function add(a, b)
        return a + b
    end

    local start_time = os.clock()
    local sum1 = 0
    for i = 1, 10000000 do
        sum1 = add(sum1, i)
    end
    local function_time = os.clock() - start_time

    start_time = os.clock()
    local sum2 = 0
    for i = 1, 10000000 do
        sum2 = sum2 + i
    end
    local inline_time = os.clock() - start_time

    print(string.format("  Function call: %.6f seconds", function_time))
    print(string.format("  Inline operation: %.6f seconds", inline_time))
    print(string.format("  Improvement: %.2f%%", (1 - inline_time / function_time) * 100))
end

test_function_calls()

-- ========== String Optimizations ==========
print("\n--- String Optimizations ---")

-- String concatenation
local function test_string_concat()
    print("Testing string concatenation methods:")

    -- Using .. operator in a loop
    local start_time = os.clock()
    local str1 = ""
    for i = 1, 10000 do
        str1 = str1 .. "x"
    end
    local concat_time = os.clock() - start_time

    -- Using table.concat
    start_time = os.clock()
    local t = {}
    for i = 1, 10000 do
        t[i] = "x"
    end
    local str2 = table.concat(t)
    local table_concat_time = os.clock() - start_time

    print(string.format("  String concatenation (..) : %.6f seconds", concat_time))
    print(string.format("  table.concat: %.6f seconds", table_concat_time))
    print(string.format("  Improvement: %.2f%%", (1 - table_concat_time / concat_time) * 100))
end

test_string_concat()

-- ========== Memory Optimizations ==========
print("\n--- Memory Optimizations ---")

-- Reducing garbage collection pressure
local function test_gc_pressure()
    print("Testing garbage collection pressure:")

    collectgarbage("collect")
    local start_memory = collectgarbage("count")

    -- Creating many temporary strings (high GC pressure)
    local start_time = os.clock()
    local result1 = ""
    for i = 1, 10000 do
        result1 = result1 .. tostring(i)
    end
    local high_pressure_time = os.clock() - start_time

    collectgarbage("collect")
    local mid_memory = collectgarbage("count")

    -- Reducing temporary objects (lower GC pressure)
    start_time = os.clock()
    local temp = {}
    for i = 1, 10000 do
        temp[i] = tostring(i)
    end
    local result2 = table.concat(temp)
    local low_pressure_time = os.clock() - start_time

    collectgarbage("collect")
    local end_memory = collectgarbage("count")

    print(string.format("  High GC pressure: %.6f seconds", high_pressure_time))
    print(string.format("  Low GC pressure: %.6f seconds", low_pressure_time))
    print(string.format("  Improvement: %.2f%%", (1 - low_pressure_time / high_pressure_time) * 100))
    print(string.format("  Memory used (high pressure): %.2f KB", mid_memory - start_memory))
    print(string.format("  Memory used (low pressure): %.2f KB", end_memory - mid_memory))
end

test_gc_pressure()

-- ========== Algorithmic Optimizations ==========
print("\n--- Algorithmic Optimizations ---")

-- Memoization example (caching function results)
local function test_memoization()
    print("Testing memoization for fibonacci:")

    -- Recursive fibonacci without memoization
    local function fib_recursive(n)
        if n <= 1 then return n end
        return fib_recursive(n - 1) + fib_recursive(n - 2)
    end

    -- Fibonacci with memoization
    local function fib_memoized(n)
        local memo = { [0] = 0, [1] = 1 }

        local function fib(n)
            if memo[n] ~= nil then
                return memo[n]
            end
            memo[n] = fib(n - 1) + fib(n - 2)
            return memo[n]
        end

        return fib(n)
    end

    -- Test with a smaller number since recursive version is exponential
    local n = 30

    local start_time = os.clock()
    local result1 = fib_recursive(n)
    local recursive_time = os.clock() - start_time

    start_time = os.clock()
    local result2 = fib_memoized(n)
    local memoized_time = os.clock() - start_time

    print(string.format("  Recursive (n=%d): %.6f seconds", n, recursive_time))
    print(string.format("  Memoized (n=%d): %.6f seconds", n, memoized_time))
    print(string.format("  Improvement: %.2f%%", (1 - memoized_time / recursive_time) * 100))
end

test_memoization()

-- ========== LuaJIT-specific Optimizations ==========
print("\n--- LuaJIT-specific Optimizations ---")

-- Check if we're running on LuaJIT
local is_luajit = type(jit) == "table"
if is_luajit then
    print("LuaJIT detected. Additional LuaJIT optimizations:")

    -- FFI vs regular Lua (if available)
    local has_ffi, ffi = pcall(require, "ffi")
    if has_ffi then
        print("\n  Testing FFI vs regular Lua:")

        -- Using regular Lua
        local start_time = os.clock()
        local sum1 = 0
        for i = 1, 10000000 do
            sum1 = sum1 + i
        end
        local lua_time = os.clock() - start_time

        -- Using FFI
        ffi.cdef [[
            typedef struct { int value; } Number;
        ]]
        start_time = os.clock()
        local num = ffi.new("Number")
        for i = 1, 10000000 do
            num.value = num.value + i
        end
        local ffi_time = os.clock() - start_time

        print(string.format("    Regular Lua: %.6f seconds", lua_time))
        print(string.format("    Using FFI: %.6f seconds", ffi_time))
        print(string.format("    Ratio: %.2fx", lua_time / ffi_time))
    else
        print("  FFI module not available for testing")
    end
else
    print("Running on standard Lua (not LuaJIT)")
    print("For additional optimizations, consider using LuaJIT which offers:")
    print("  - Just-In-Time compilation")
    print("  - Trace compiler optimizations")
    print("  - FFI for C integration without overhead")
    print("  - Better performance for numerical code")
end

print("\n=== Optimization Summary ===")
print("The most significant performance improvements generally come from:")
print("1. Algorithm selection (O(n²) → O(n log n) → O(n))")
print("2. Memoization and caching of expensive results")
print("3. Avoiding unnecessary memory allocations")
print("4. Local variables instead of table lookups")
print("5. For numerical arrays, numeric for loops instead of iterators")
print("6. table.concat instead of string concatenation in loops")
print("7. Cache frequently-used functions in upvalues")
print("8. In LuaJIT, using FFI for performance-critical code")
print("9. Minimizing function calls in tight loops")
print("10. Understanding and managing garbage collection")
