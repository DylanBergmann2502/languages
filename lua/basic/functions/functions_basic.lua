-- functions_basic.lua

-- Basic function declaration
local function say_hello()
    print("Hello from Lua!")
end

-- Function with parameters
local function greet(name)
    print("Hello, " .. name .. "!")
end

-- Function with return value
local function add(a, b)
    return a + b
end

-- Function with multiple parameters and default values
local function introduce(name, age, job)
    job = job or "unknown profession"
    print(name .. " is " .. age .. " years old and works as a " .. job)
end

-- Functions can be assigned to variables (first-class citizens)
local multiply = function(a, b)
    return a * b
end

-- Local functions (scoped to the file/chunk)
local function divide(a, b)
    if b == 0 then
        return "Cannot divide by zero"
    end
    return a / b
end

-- Anonymous functions
local square = function(x) return x * x end

-- Calling our functions
print("Basic function call:")
    say_hello()

print("\nFunction with parameter:")
greet("Python developer")

print("\nFunction with return value:")
local sum = add(5, 7)
print("5 + 7 = " .. sum)

print("\nFunction with default parameter:")
introduce("Alex", 28)
introduce("Maria", 34, "software engineer")

print("\nFunction assigned to variable:")
local product = multiply(6, 8)
print("6 * 8 = " .. product)

print("\nLocal function call:")
print("10 / 2 = " .. divide(10, 2))
print("10 / 0 = " .. divide(10, 0))

print("\nAnonymous function:")
print("5² = " .. square(5))

-- Functions can be passed as arguments
local function apply_operation(x, y, operation)
    return operation(x, y)
end

print("\nFunction as argument:")
print("Operation result: " .. apply_operation(10, 20, add))
print("Operation result: " .. apply_operation(10, 20, multiply))

-- Function with variable number of arguments
function sum(...)
    local total = 0
    for _, value in ipairs({ ... }) do
        total = total + value
    end
    return total
end

print("\nVariable arguments:")
print("Sum of 1,2,3: " .. sum(1, 2, 3))
print("Sum of 5,10,15,20: " .. sum(5, 10, 15, 20))
