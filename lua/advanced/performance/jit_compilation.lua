-- jit_compilation.lua
-- Exploring JIT compilation with LuaJIT

-- First, check if we're running on LuaJIT
local is_luajit = type(jit) == "table"

if not is_luajit then
    print("=== This script requires LuaJIT ===")
    print("You're currently running regular Lua. Please run this script with LuaJIT.")
    print("Download LuaJIT from: https://luajit.org/download.html")
    os.exit(1)
end

print("=== JIT Compilation in LuaJIT ===")
print("LuaJIT version: " .. jit.version)

-- ========== JIT Status and Control ==========
print("\n--- JIT Status and Control ---")

-- Display current JIT status
print("JIT status: " .. (jit.status() and "enabled" or "disabled"))

-- Basic JIT control functions (from jit.* library)
print("\nJIT control functions:")
print("  jit.on()    - Enable JIT compiler globally")
print("  jit.off()   - Disable JIT compiler globally")
print("  jit.flush() - Flush the entire cache of compiled code")

-- ========== JIT Compiler Basics ==========
print("\n--- JIT Compiler Basics ---")

print("LuaJIT uses a tracing JIT compiler that works as follows:")
print("1. Code first runs in the interpreter")
print("2. 'Hot' code paths (loops) that execute frequently are identified")
print("3. These hot paths are recorded as traces")
print("4. Traces are optimized and compiled to machine code")
print("5. Future executions of the same code use the compiled version")

-- ========== Demonstration Functions ==========
print("\n--- Performance Demonstration ---")

-- Function to benchmark execution time
local function benchmark(name, iterations, func, ...)
    local start = os.clock()
    local result = func(iterations, ...)
    local elapsed = os.clock() - start
    print(string.format("%s: %.6f seconds, result: %s",
        name, elapsed, tostring(result)))
    return elapsed
end

-- Simple loop function for benchmarking
local function test_loop(iterations)
    local sum = 0
    for i = 1, iterations do
        sum = sum + i
    end
    return sum
end

-- Function with unpredictable branches (harder to JIT optimize)
local function test_branchy(iterations)
    local sum = 0
    for i = 1, iterations do
        if i % 2 == 0 then
            sum = sum + i
        elseif i % 3 == 0 then
            sum = sum - (i / 3)
        else
            sum = sum + (i * 0.5)
        end
    end
    return sum
end

-- Function with type instability (challenging for JIT)
local function test_type_instability(iterations)
    local result = 0
    for i = 1, iterations do
        if i % 2 == 0 then
            result = result + i    -- number
        else
            result = result .. "x" -- string
        end
    end
    return result
end

-- Mathematical function (good for JIT)
local function test_math(iterations)
    local result = 0
    for i = 1, iterations do
        result = result + math.sin(i * 0.01) * math.cos(i * 0.01)
    end
    return result
end

-- ========== JIT Optimization vs Interpreter ==========
print("\nRunning benchmarks with JIT enabled...")

local iterations = 10000000 -- Large enough to trigger JIT compilation
local jit_loop = benchmark("Simple loop (JIT)", iterations, test_loop)
local jit_branchy = benchmark("Branchy code (JIT)", iterations / 10, test_branchy)

-- Only run a small number for the type instability test - it's slow!
local mini_iterations = 1000
local jit_type_instability = benchmark("Type instability (JIT)", mini_iterations, test_type_instability)
local jit_math = benchmark("Math functions (JIT)", iterations, test_math)

-- Now disable JIT and compare
print("\nDisabling JIT for comparison...")
jit.off()
print("JIT status: " .. (jit.status() and "enabled" or "disabled"))

local nojit_loop = benchmark("Simple loop (Interpreter)", iterations, test_loop)
local nojit_branchy = benchmark("Branchy code (Interpreter)", iterations / 10, test_branchy)
local nojit_type_instability = benchmark("Type instability (Interpreter)", mini_iterations, test_type_instability)
local nojit_math = benchmark("Math functions (Interpreter)", iterations, test_math)

-- Re-enable JIT
jit.on()

-- Show improvements
print("\nPerformance improvements with JIT:")
print(string.format("Simple loop: %.2fx faster", nojit_loop / jit_loop))
print(string.format("Branchy code: %.2fx faster", nojit_branchy / jit_branchy))
print(string.format("Type instability: %.2fx faster", nojit_type_instability / jit_type_instability))
print(string.format("Math functions: %.2fx faster", nojit_math / jit_math))

-- ========== Trace Information ==========
print("\n--- Trace Information ---")

-- Get jit.dump module if available
local has_dump, dump = pcall(require, "jit.dump")
if has_dump then
    print("JIT dump module available - you can use it to analyze JIT compilation")
    print("Usage example: require('jit.dump').start('s')")
    print("See LuaJIT documentation for more options")
else
    print("JIT dump module not available - full trace info not accessible")
end

-- Get jit.v module if available
local has_v, v = pcall(require, "jit.v")
if has_v then
    print("\nTo see JIT compilation activity, you can use:")
    print("require('jit.v').start()")
else
    print("\njit.v module not available")
end

-- ========== JIT Compilation Hints ==========
print("\n--- JIT Compilation Hints ---")

-- Demonstrate jit.opt for compiler options
local has_opt, opt = pcall(require, "jit.opt")
if has_opt then
    print("JIT optimizer module available")
    print("Usage: require('jit.opt').start('level=2')")
else
    print("JIT optimizer module not available")
end

-- ========== JIT-Friendly Code Patterns ==========
print("\n--- JIT-Friendly Code Patterns ---")

print("Code patterns that work well with LuaJIT:")
print("1. Predictable type usage (avoid mixing types in variables)")
print("2. Simple, tight loops with consistent behavior")
print("3. Array tables with numeric keys starting at 1")
print("4. Predictable branching patterns")
print("5. Math-heavy code without type changes")

print("\nCode patterns that may hinder JIT compilation:")
print("1. Functions with too many branches or complex control flow")
print("2. Variables that change types frequently")
print("3. Using debugger or debug hooks")
print("4. Deep recursion (trace exits)")
print("5. Operations that can't be inlined or specialized")

-- ========== FFI for Maximum Performance ==========
print("\n--- FFI for Maximum Performance ---")

local has_ffi, ffi = pcall(require, "ffi")
if has_ffi then
    print("LuaJIT FFI library is available")
    print("FFI allows calling C functions directly with minimal overhead")

    -- Simple FFI example
    print("\nFFI example (array summation):")

    -- Create a large array via FFI
    ffi.cdef [[
        typedef struct { double values[10000000]; } Array;
    ]]

    local function sum_ffi(iterations)
        local array = ffi.new("Array")
        -- Initialize array
        for i = 0, iterations - 1 do
            array.values[i] = i
        end

        -- Sum array via FFI
        local sum = 0
        for i = 0, iterations - 1 do
            sum = sum + array.values[i]
        end
        return sum
    end

    local function sum_lua(iterations)
        local array = {}
        -- Initialize array
        for i = 1, iterations do
            array[i] = i - 1 -- Adjust to match FFI example
        end

        -- Sum array via Lua
        local sum = 0
        for i = 1, iterations do
            sum = sum + array[i]
        end
        return sum
    end

    local small_iter = 1000000 -- Use smaller number for quicker test
    print("Running array sum benchmark...")

    jit.on() -- Make sure JIT is on
    local ffi_time = benchmark("FFI array sum", small_iter, sum_ffi)
    local lua_time = benchmark("Lua array sum", small_iter, sum_lua)

    print(string.format("FFI vs Lua array: %.2fx difference", lua_time / ffi_time))
else
    print("LuaJIT FFI library is not available")
    print("FFI provides the highest performance in LuaJIT by allowing direct C calls")
end

-- ========== Practical Tips ==========
print("\n--- Practical JIT Optimization Tips ---")

print("1. Profile your code to find bottlenecks before optimizing")
print("2. Keep hot loops simple and type-consistent")
print("3. Use FFI for performance-critical sections")
print("4. Cache external function lookups in locals")
print("5. Use LuaJIT specific features when available")
print("6. Understand what causes trace aborts (complex control flow)")
print("7. Use -joff flag to compare JIT vs interpreter performance")
print("8. For detailed analysis, use jit.dump and jit.v modules")
print("9. Consider data layout for cache friendliness")
print("10. Avoid unnecessary memory allocations in hot loops")

print("\n=== JIT Compilation Complete ===")
