-- variable_args.lua

-- Basic variadic function using ... (ellipsis)
local function sum(...)
    local total = 0
    -- Convert ... to a table using {...}
    local args = { ... }

    for i, value in ipairs(args) do
        total = total + value
    end

    return total
end

print("Sum of 1, 2, 3:", sum(1, 2, 3))                 -- Sum of 1, 2, 3: 6
print("Sum of 5, 10, 15, 20:", sum(5, 10, 15, 20))     -- Sum of 5, 10, 15, 20: 50
print("Sum with no args:", sum())                      -- Sum with no args: 0

-- Direct iteration of variable args
local function print_args(...)
    print("Number of arguments:", select("#", ...))
    for i = 1, select("#", ...) do
        local arg = select(i, ...)
        print("Argument", i, "=", arg)
    end
end

print("\nPrinting various arguments:")
print_args("hello", 42, true, { name = "Lua" })

-- Combining fixed parameters with variable args
local function greet(name, ...)
    print("Hello, " .. name .. "!")

    local titles = { ... }
    if #titles > 0 then
        print("Your titles are:")
        for i, title in ipairs(titles) do
            print("  - " .. title)
        end
    end
end

print("\nGreeting with fixed and variable args:")
greet("Alex")
print()
greet("Maria", "Developer", "Team Lead", "Architect")

-- Passing variable args to another function
local function pass_through(...)
    print("Passing all arguments to sum():")
    local result = sum(...)
    return result
end

print("\nPassing through variable args:", pass_through(1, 2, 3, 4, 5))

-- Unpacking a table as arguments
local function multiply(a, b, c)
    return a * b * c
end

local numbers = { 2, 3, 4 }
print("\nUnpacking a table as arguments:")
print("Multiplying", table.unpack(numbers), "=", multiply(table.unpack(numbers)))

-- Handling different types in variable args
local function describe_args(...)
    local args = { ... }
    for i, arg in ipairs(args) do
        print(string.format("Argument %d is a %s: %s",
            i,
            type(arg),
            tostring(arg)))
    end
end

print("\nDescribing different types:")
describe_args("string", 42, true, { 1, 2, 3 }, function() return "hi" end)
