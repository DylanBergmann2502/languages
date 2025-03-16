-- first_class_functions.lua

-- In Lua, functions are "first-class citizens" which means they can be:
-- 1. Assigned to variables
-- 2. Passed as arguments to other functions
-- 3. Returned from functions
-- 4. Stored in tables

-- 1. Assigning functions to variables
local add = function(a, b)
    return a + b
end

print("Result of add(5, 3):", add(5, 3)) -- 8

-- Alternative syntax for function definition
local function subtract(a, b)
    return a - b
end

print("Result of subtract(10, 4):", subtract(10, 4)) -- 6

-- Functions can be reassigned
local operation = add
print("operation(5, 3):", operation(5, 3)) -- 8

operation = subtract
print("operation(10, 4):", operation(10, 4)) -- 6

-- 2. Passing functions as arguments
local function apply_operation(func, x, y)
    return func(x, y)
end

print("apply_operation(add, 7, 3):", apply_operation(add, 7, 3))           -- 10
print("apply_operation(subtract, 7, 3):", apply_operation(subtract, 7, 3)) -- 4

-- 3. Returning functions from functions
local function make_multiplier(factor)
    -- Returns a new function that multiplies its argument by factor
    return function(x)
        return x * factor
    end
end

local double = make_multiplier(2)
local triple = make_multiplier(3)

print("double(5):", double(5)) -- 10
print("triple(5):", triple(5)) -- 15

-- 4. Storing functions in tables
local math_operations = {
    add = add,
    subtract = subtract,
    multiply = function(a, b) return a * b end,
    divide = function(a, b) return a / b end
}

print("math_operations.add(10, 5):", math_operations.add(10, 5))           -- 15
print("math_operations.multiply(10, 5):", math_operations.multiply(10, 5)) -- 50

-- Common use case: Higher-order functions with tables
local numbers = { 1, 2, 3, 4, 5 }

local function map(tbl, func)
    local result = {}
    for i, v in ipairs(tbl) do
        result[i] = func(v)
    end
    return result
end

local doubled_numbers = map(numbers, double)
print("Doubled numbers:")
for i, v in ipairs(doubled_numbers) do
    print(v) -- 2, 4, 6, 8, 10
end

-- Anonymous functions (lambdas)
local squared_numbers = map(numbers, function(x) return x * x end)
print("Squared numbers:")
for i, v in ipairs(squared_numbers) do
    print(v) -- 1, 4, 9, 16, 25
end
