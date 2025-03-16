-- table_operations.lua
-- Demonstration of operations using the table library and common table techniques

-- The table library provides several functions for working with tables
print("== TABLE LIBRARY OPERATIONS ==")

-- table.insert - Add an element to a table (typically array-like tables)
local fruits = { "apple", "banana", "orange" }

table.insert(fruits, "grape") -- Insert at the end
print("\ntable.insert(fruits, \"grape\"):")
for i, v in ipairs(fruits) do
    print(i, v)
end

table.insert(fruits, 2, "pear") -- Insert at position 2
print("\ntable.insert(fruits, 2, \"pear\"):")
for i, v in ipairs(fruits) do
    print(i, v)
end

-- table.remove - Remove an element from a table and return it
local removed = table.remove(fruits, 3) -- Remove element at index 3
print("\ntable.remove(fruits, 3):")
print("Removed item:", removed)
for i, v in ipairs(fruits) do
    print(i, v)
end

local last_item = table.remove(fruits) -- Remove last element when no index specified
print("\ntable.remove(fruits):")
print("Removed last item:", last_item)
for i, v in ipairs(fruits) do
    print(i, v)
end

-- table.move - Move elements from one position/table to another
local numbers = { 1, 2, 3, 4, 5 }
local target = { 10, 20, 30 }

-- Move elements 2-4 from numbers to target starting at index 2
table.move(numbers, 2, 4, 2, target)
print("\ntable.move(numbers, 2, 4, 2, target):")
print("Source table remains:")
for i, v in ipairs(numbers) do
    print(i, v)
end
print("Target table after move:")
for i, v in ipairs(target) do
    print(i, v)
end

-- table.concat - Join array elements into a string
local words = { "Hello", "Lua", "world" }
local sentence = table.concat(words, " ")
print("\ntable.concat(words, \" \"):")
print(sentence)

-- With range parameters (start and end indices)
print(table.concat(words, "-", 2, 3)) -- Concat elements 2-3 with "-"

-- table.sort - Sort a table in-place
local scores = { 75, 42, 90, 18, 63 }
table.sort(scores) -- Default: ascending order
print("\ntable.sort(scores):")
for i, v in ipairs(scores) do
    print(i, v)
end

-- Custom sort function (descending order)
table.sort(scores, function(a, b) return a > b end)
print("\ntable.sort with custom comparator (descending):")
for i, v in ipairs(scores) do
    print(i, v)
end

-- Sort by specific field in a table of tables
local students = {
    { name = "Alice",   grade = 85 },
    { name = "Bob",     grade = 92 },
    { name = "Charlie", grade = 78 }
}

table.sort(students, function(a, b) return a.grade > b.grade end)
print("\nSorting table of tables by grade:")
for i, student in ipairs(students) do
    print(i, student.name, student.grade)
end

-- table.pack and table.unpack (Lua 5.2+)
print("\ntable.pack and table.unpack:")
local packed = table.pack(10, 20, 30, 40)
print("Packed table size:", packed.n)      -- table.pack sets the 'n' field

local a, b, c = table.unpack(packed, 1, 3) -- Unpack only first 3 elements
print("Unpacked values:", a, b, c)

-- == COMMON TABLE OPERATIONS (WITHOUT USING TABLE LIBRARY) ==
print("\n== COMMON TABLE OPERATIONS ==")

-- Finding a value in a table
local function find(t, value)
    for i, v in ipairs(t) do
        if v == value then
            return i
        end
    end
    return nil
end

local colors = { "red", "green", "blue", "yellow" }
local position = find(colors, "blue")
print("\nFind \"blue\" in colors table: index", position)

-- Checking if a value exists in a table
local function contains(t, value)
    for _, v in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

print("Table contains \"purple\":", contains(colors, "purple"))
print("Table contains \"red\":", contains(colors, "red"))

-- Merging two tables
local function merge(t1, t2)
    local result = {}
    for k, v in pairs(t1) do
        result[k] = v
    end
    for k, v in pairs(t2) do
        result[k] = v
    end
    return result
end

local defaults = { color = "blue", size = "medium" }
local userPrefs = { color = "red" }
local settings = merge(defaults, userPrefs)

print("\nMerged tables:")
for k, v in pairs(settings) do
    print(k, v)
end

-- Copying a table (shallow copy)
local function shallow_copy(t)
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = v
    end
    return copy
end

local original = { 1, 2, 3, name = "table" }
local copy = shallow_copy(original)
copy[1] = 100
copy.name = "copy"

print("\nAfter shallow copy and modification:")
print("Original table:")
for k, v in pairs(original) do
    print(k, v)
end
print("Copy:")
for k, v in pairs(copy) do
    print(k, v)
end

-- Deep copy (handles nested tables)
local function deep_copy(t)
    if type(t) ~= "table" then return t end
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = type(v) == "table" and deep_copy(v) or v
    end
    return copy
end

local nested = { a = 1, b = { c = 2, d = 3 } }
local deepCopied = deep_copy(nested)
deepCopied.b.c = 100

print("\nAfter deep copy and modification:")
print("Original nested.b.c:", nested.b.c)
print("Deep copy nested.b.c:", deepCopied.b.c)

-- Filtering a table
local function filter(t, predicate)
    local result = {}
    for i, v in ipairs(t) do
        if predicate(v) then
            table.insert(result, v)
        end
    end
    return result
end

local nums = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
local evens = filter(nums, function(x) return x % 2 == 0 end)

print("\nFiltered table (even numbers):")
for i, v in ipairs(evens) do
    print(i, v)
end

-- Creating a frequency table
local function frequency(t)
    local freq = {}
    for _, v in ipairs(t) do
        freq[v] = (freq[v] or 0) + 1
    end
    return freq
end

local items = { "apple", "orange", "apple", "banana", "orange", "apple" }
local freq_table = frequency(items)

print("\nFrequency table:")
for item, count in pairs(freq_table) do
    print(item, count)
end
