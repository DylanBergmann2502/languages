-- coroutines_basic.lua

-- Coroutines are a way to have multiple "threads" of execution in Lua
-- Unlike true threads, coroutines use cooperative multitasking (they yield voluntarily)

print("=== BASIC COROUTINE CONCEPTS ===")

-- 1. Creating a coroutine
local function count_to_five()
    for i = 1, 5 do
        print("Coroutine counting:", i)
        coroutine.yield() -- Pause execution and return control
    end
    print("Counting finished!")
end

local co = coroutine.create(count_to_five)
print("Coroutine status:", coroutine.status(co)) -- suspended

-- 2. Resuming a coroutine
print("\n--- Resuming coroutine multiple times ---")
coroutine.resume(co)                             -- Start or continue the coroutine
print("Coroutine status:", coroutine.status(co)) -- suspended

coroutine.resume(co)                             -- Continue from where it yielded
coroutine.resume(co)                             -- Continue again
coroutine.resume(co)
coroutine.resume(co)
coroutine.resume(co)                                              -- This completes the function

print("Coroutine status after completion:", coroutine.status(co)) -- dead

-- 3. Yielding and passing values
print("\n--- Yielding with values ---")
local function generate_values()
    coroutine.yield("First value")
    coroutine.yield("Second value")
    return "Final return value"
end

local co2 = coroutine.create(generate_values)

local success1, value1 = coroutine.resume(co2)
print("First resume:", success1, value1)

local success2, value2 = coroutine.resume(co2)
print("Second resume:", success2, value2)

local success3, value3 = coroutine.resume(co2)
print("Third resume:", success3, value3)

-- 4. Coroutine.wrap - a simpler interface
print("\n--- Using coroutine.wrap ---")
local generator = coroutine.wrap(function()
    for i = 1, 3 do
        coroutine.yield(i * 10)
    end
end)

-- No need to use resume with wrap, just call it like a function
print("First value:", generator())
print("Second value:", generator())
print("Third value:", generator())

-- 5. Error handling in coroutines
print("\n--- Error handling in coroutines ---")
local function dangerous_function()
    print("Starting dangerous work...")
    coroutine.yield("Halfway done")
    error("Something went wrong!")
end

local co_error = coroutine.create(dangerous_function)
local success, message = coroutine.resume(co_error)
print("First run:", success, message)

local success, error_message = coroutine.resume(co_error)
print("Second run:", success, error_message)

-- 6. Implementing a simple iterator with coroutines
print("\n--- Coroutine as an iterator ---")
local function range(from, to, step)
    step = step or 1
    return coroutine.wrap(function()
        local i = from
        while i <= to do
            coroutine.yield(i)
            i = i + step
        end
    end)
end

print("Counting by 2s:")
for num in range(1, 10, 2) do
    print(num)
end

-- 7. Producer-consumer pattern (basic)
print("\n--- Simple producer-consumer ---")
local function producer()
    return coroutine.create(function()
        for i = 1, 5 do
            local item = "item_" .. i
            print("Producing", item)
            coroutine.yield(item)
        end
    end)
end

local function consumer(prod)
    while coroutine.status(prod) ~= "dead" do
        local success, item = coroutine.resume(prod)
        if success and item then
            print("Consuming", item)
        end
    end
end

consumer(producer())
