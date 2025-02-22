-- break_return.lua

-- Basic break example
print("Break in a loop:")
for i = 1, 5 do
    if i == 3 then
        break
    end
    print("Number: " .. i)
end
-- Output:
-- Number: 1
-- Number: 2

-- Break with nested loops
print("\nBreak in nested loops:")
for i = 1, 3 do
    for j = 1, 3 do
        if i * j > 4 then
            print("Breaking at i=" .. i .. ", j=" .. j)
            break -- only breaks the inner loop
        end
        print(i .. "x" .. j .. "=" .. i * j)
    end
end
-- Output:
-- 1x1=1
-- 1x2=2
-- 1x3=3
-- 2x1=2
-- 2x2=4
-- Breaking at i=2, j=3
-- 3x1=3
-- 3x2=6
-- Breaking at i=3, j=2

-- Return from a function
local function find_number(numbers, target)
    for i, num in ipairs(numbers) do
        if num == target then
            return i -- immediately exits the function
        end
    end
    return nil -- if number not found
end

local numbers = { 10, 20, 30, 40, 50 }
local index = find_number(numbers, 30)
print("\nFound number at index:", index) -- Output: Found number at index: 3

-- Multiple returns
local function divide_and_remainder(a, b)
    if b == 0 then
        return nil, "Cannot divide by zero"
    end
    return math.floor(a / b), a % b
end

local quotient, remainder = divide_and_remainder(17, 5)
print("\nDivision result:", quotient, remainder) -- Output: Division result: 3 2

-- Early return for validation
local function process_user(user)
    if not user.name then
        return nil, "Name is required"
    end
    if not user.age or user.age < 0 then
        return nil, "Invalid age"
    end

    return "Processing user: " .. user.name
end

local result, error = process_user({ name = "John", age = -5 })
print("\nProcess result:", result or error) -- Output: Process result: Invalid age

-- Using break in while true loop (common pattern)
print("\nSearching with while true:")
local counter = 1
while true do
    if counter > 3 then
        break
    end
    print("Iteration " .. counter)
    counter = counter + 1
end
