-- loops.lua

-- While loop
print("While loop:")
local count = 1
while count <= 3 do
    print("Count is: " .. count)
    count = count + 1
end
-- Output:
-- Count is: 1
-- Count is: 2
-- Count is: 3

-- Repeat-until loop (runs at least once)
print("\nRepeat-until loop:")
local num = 1
repeat
    print("Number is: " .. num)
    num = num + 1
until num > 3
-- Output:
-- Number is: 1
-- Number is: 2
-- Number is: 3

-- Numeric for loop
-- for variable = start, end, step do
print("\nNumeric for loop:")
for i = 1, 5, 2 do  -- Count from 1 to 5, stepping by 2
    print("i is: " .. i)
end
-- Output:
-- i is: 1
-- i is: 3
-- i is: 5

-- Counting backwards
print("\nCounting backwards:")
for i = 10, 1, -2 do  -- Count from 10 to 1, stepping by -2
    print("i is: " .. i)
end
-- Output:
-- i is: 10
-- i is: 8
-- i is: 6
-- i is: 4
-- i is: 2

-- Generic for loop with ipairs (array-like iteration)
print("\nGeneric for with ipairs:")
local fruits = {"apple", "banana", "orange"}
for i, fruit in ipairs(fruits) do
    print(i .. ": " .. fruit)
end
-- Output:
-- 1: apple
-- 2: banana
-- 3: orange

-- Generic for loop with pairs (table iteration)
print("\nGeneric for with pairs:")
local person = {
    name = "John",
    age = 30,
    city = "New York"
}
for key, value in pairs(person) do
    print(key .. ": " .. value)
end
-- Output (order may vary as tables are not ordered):
-- name: John
-- age: 30
-- city: New York

-- Breaking out of loops
print("\nBreaking out of a loop:")
for i = 1, 10 do
    if i > 3 then
        break
    end
    print("Value: " .. i)
end
-- Output:
-- Value: 1
-- Value: 2
-- Value: 3