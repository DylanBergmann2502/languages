-- table_library.lua
-- Comprehensive exploration of Lua's table library functions

-- =========================================================
-- table.insert - Adds an element to a table
-- =========================================================
print("=== table.insert ===")

local fruits = { "apple", "orange", "banana" }

-- Insert at the end (default behavior)
table.insert(fruits, "grape")
print("After inserting at end:")
for i, v in ipairs(fruits) do
    print(i, v)
end

-- Insert at a specific position
table.insert(fruits, 2, "kiwi")
print("\nAfter inserting at position 2:")
for i, v in ipairs(fruits) do
    print(i, v)
end

-- =========================================================
-- table.remove - Removes and returns an element
-- =========================================================
print("\n=== table.remove ===")

local vegetables = { "carrot", "potato", "cucumber", "tomato", "onion" }

-- Remove from a specific position
local removed = table.remove(vegetables, 3)
print("Removed item:", removed)
print("After removing from position 3:")
for i, v in ipairs(vegetables) do
    print(i, v)
end

-- Remove from the end (default behavior)
local lastItem = table.remove(vegetables)
print("\nRemoved last item:", lastItem)
print("After removing last item:")
for i, v in ipairs(vegetables) do
    print(i, v)
end

-- =========================================================
-- table.concat - Joins array elements into a string
-- =========================================================
print("\n=== table.concat ===")

local words = { "Hello", "Lua", "table", "library" }

-- Basic concatenation with separator
local sentence = table.concat(words, " ")
print("Basic concatenation:", sentence)

-- With range parameters (start and end)
print("Concat elements 2-3:", table.concat(words, "-", 2, 3))
print("Concat from element 3:", table.concat(words, " ", 3))
print("Concat up to element 2:", table.concat(words, " ", 1, 2))

-- Empty separator
print("Concat with empty separator:", table.concat(words))

-- =========================================================
-- table.sort - Sorts a table in-place
-- =========================================================
print("\n=== table.sort ===")

local numbers = { 5, 2, 8, 1, 7, 3 }

-- Default sort (ascending)
table.sort(numbers)
print("Default sort (ascending):")
for i, v in ipairs(numbers) do
    print(i, v)
end

-- Custom comparison function (descending)
table.sort(numbers, function(a, b) return a > b end)
print("\nCustom sort (descending):")
for i, v in ipairs(numbers) do
    print(i, v)
end

-- Sorting strings
local names = { "David", "alice", "Bob", "charlie" }
table.sort(names)
print("\nDefault string sort (case-sensitive):")
for i, v in ipairs(names) do
    print(i, v)
end

-- Case-insensitive sort
table.sort(names, function(a, b)
    return string.lower(a) < string.lower(b)
end)
print("\nCase-insensitive sort:")
for i, v in ipairs(names) do
    print(i, v)
end

-- Sorting a table of tables by a field
local students = {
    { name = "Alice",   score = 85 },
    { name = "Bob",     score = 92 },
    { name = "Charlie", score = 78 },
    { name = "Diana",   score = 95 }
}

table.sort(students, function(a, b)
    return a.score > b.score
end)
print("\nSort by student score (descending):")
for i, student in ipairs(students) do
    print(i, student.name, student.score)
end

-- =========================================================
-- table.move - Moves elements from one position/table to another
-- =========================================================
print("\n=== table.move ===")

local source = { 10, 20, 30, 40, 50 }
local target = { 1, 2, 3, 4, 5 }

-- Move within the same table
table.move(source, 2, 4, 1) -- Move elements 2-4 to position 1
print("After moving within same table:")
for i, v in ipairs(source) do
    print(i, v)
end

-- Reset source
source = { 10, 20, 30, 40, 50 }

-- Move to another table
table.move(source, 2, 4, 3, target)
print("\nSource after moving to target:")
for i, v in ipairs(source) do
    print(i, v)
end
print("\nTarget after receiving elements:")
for i, v in ipairs(target) do
    print(i, v)
end

-- Creating a copy with table.move
local copy = {}
table.move(source, 1, #source, 1, copy)
print("\nCopy created with table.move:")
for i, v in ipairs(copy) do
    print(i, v)
end

-- =========================================================
-- table.pack - Packs arguments into a table (Lua 5.2+)
-- =========================================================
print("\n=== table.pack ===")

local function pack_demo(...)
    local args = table.pack(...)
    print("Number of arguments:", args.n)
    print("Arguments:")
    for i = 1, args.n do
        print(i, args[i])
    end
    return args
end

local packed = pack_demo("hello", 42, true, nil, "world")
print("Packed table includes 'n' field:", packed.n)

-- =========================================================
-- table.unpack - Extracts values from a table as multiple results (Lua 5.2+)
-- =========================================================
print("\n=== table.unpack ===")

local values = { 100, 200, 300, 400, 500 }

-- Basic unpacking
local a, b, c = table.unpack(values)
print("Unpacked first three values:", a, b, c)

-- Unpacking with range
local x, y = table.unpack(values, 3, 4) -- Elements 3-4 only
print("Unpacked elements 3-4:", x, y)

-- Function that uses unpack
local function printCoordinates(...)
    print(...)
end

local point = { 10, 20, 30 } -- x, y, z coordinates
print("Calling function with unpacked coordinates:")
printCoordinates(table.unpack(point))

-- =========================================================
-- table.maxn - Returns largest positive numerical index (Lua 5.1)
-- In newer Lua versions, you can use # for sequential arrays
-- =========================================================
print("\n=== Finding largest index ===")

local sparse_array = {}
sparse_array[1] = "first"
sparse_array[5] = "fifth"
sparse_array[100] = "hundredth"

-- In Lua 5.2+, table.maxn is removed, but we can implement it
local function maxn(t)
    local max = 0
    for k in pairs(t) do
        if type(k) == "number" and k > max then
            max = k
        end
    end
    return max
end

print("Largest numeric index:", maxn(sparse_array))
print("Length operator result:", #sparse_array) -- Only counts sequential part

-- =========================================================
-- Creating utility functions to extend the table library
-- =========================================================
print("\n=== Custom table utilities ===")

-- Deep copy of a table
local function deep_copy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            v = deep_copy(v)
        end
        copy[k] = v
    end
    return copy
end

local nested = { a = 1, b = { c = 2, d = { e = 3 } } }
local deep_copied = deep_copy(nested)
deep_copied.b.d.e = 100

print("Original nested value:", nested.b.d.e)
print("Deep copied and modified value:", deep_copied.b.d.e)

-- Find value in a table
local function find(t, value)
    for i, v in ipairs(t) do
        if v == value then
            return i
        end
    end
    return nil
end

local colors = { "red", "green", "blue", "yellow" }
print("\nFind 'blue' in colors:", find(colors, "blue"))
print("Find 'purple' in colors:", find(colors, "purple"))

-- Count occurrences in a table
local function count(t, value)
    local counter = 0
    for _, v in pairs(t) do
        if v == value then
            counter = counter + 1
        end
    end
    return counter
end

local items = { "apple", "orange", "apple", "banana", "apple" }
print("\nNumber of 'apple' occurrences:", count(items, "apple"))
