-- upvalues.lua

-- Upvalues are variables from outer scopes that are "captured" by inner functions
-- They enable closures and allow functions to maintain state between calls

-- 1. Basic upvalue example
local function create_counter()
    local count = 0 -- This becomes an upvalue for the inner function

    return function()
        count = count + 1 -- Accessing and modifying the upvalue
        return count
    end
end

local counter = create_counter()
print("Counter:", counter()) -- 1
print("Counter:", counter()) -- 2
print("Counter:", counter()) -- 3

-- 2. Multiple upvalues
local function create_adder(x)
    -- x is an upvalue in the returned function
    return function(y)
        return x + y -- x is accessed as an upvalue
    end
end

local add5 = create_adder(5)
local add10 = create_adder(10)

print("add5(3):", add5(3))   -- 8
print("add10(3):", add10(3)) -- 13

-- 3. Shared upvalues between multiple functions
local function create_counter_pair()
    local count = 0 -- This upvalue is shared between increment and get

    local function increment()
        count = count + 1
    end

    local function get()
        return count
    end

    return {
        increment = increment,
        get = get
    }
end

local counter_pair = create_counter_pair()
counter_pair.increment()
counter_pair.increment()
print("Counter value:", counter_pair.get()) -- 2

-- 4. Examining upvalues with the debug library
local function show_upvalues(func)
    local i = 1
    while true do
        local name, value = debug.getupvalue(func, i)
        if not name then break end
        print(string.format("Upvalue #%d: %s = %s", i, name, tostring(value)))
        i = i + 1
    end
end

print("\nExamining upvalues of counter function:")
show_upvalues(counter)

print("\nExamining upvalues of add5 function:")
show_upvalues(add5)

-- 5. Mutating upvalues with debug.setupvalue
local function mutate_counter()
    -- Reset the counter's upvalue to 100
    debug.setupvalue(counter, 1, 100)
end

mutate_counter()
print("\nAfter mutation, counter:", counter()) -- 101

-- 6. Upvalues and local variable lifecycle
local function create_functions()
    local funcs = {}

    for i = 1, 3 do
        -- Each iteration creates a new local 'i' that's captured as an upvalue
        funcs[i] = function() return i end
    end

    return funcs
end

local functions = create_functions()
for i, func in ipairs(functions) do
    print("Function", i, "returns", func()) -- All return their respective i values
end

-- 7. Common gotcha with upvalues in loops
local bad_funcs = {}
for i = 1, 3 do
    -- Here all functions capture the same 'i' variable
    bad_funcs[i] = function() return i end
end

-- Loop completes with i = 4
for i, func in ipairs(bad_funcs) do
    print("Bad function", i, "returns", func()) -- All return 4 in Lua 5.1, correct in 5.2+
end

-- 8. Performance implications
local function time_function(func, iterations)
    local start = os.clock()
    local result
    for i = 1, iterations do
        result = func(i)
    end
    return os.clock() - start, result
end

-- Function using an upvalue
local upvalue = 5
local function with_upvalue(x)
    return x + upvalue
end

-- Function using only local variables
local function no_upvalue(x)
    local val = 5
    return x + val
end

local iterations = 10000000
print("\nPerformance test with", iterations, "iterations:")
local time1, _ = time_function(with_upvalue, iterations)
local time2, _ = time_function(no_upvalue, iterations)
print("Time with upvalue:", time1)
print("Time without upvalue:", time2)
print("Ratio:", time1 / time2)
