-- arrays.lua
-- Lua tables used as arrays demonstration

-- In Lua, arrays are implemented using tables
-- Arrays typically use sequential integer indices starting from 1

-- Creating an array
local fruits = { "apple", "banana", "orange", "grape", "mango" }

-- Printing the array elements
print("Fruits array:")
for i = 1, #fruits do -- #fruits gives the length of the array
    print(i, fruits[i])
end

-- Adding elements to the end of an array
fruits[#fruits + 1] = "pineapple"  -- append to end
-- or use table.insert
table.insert(fruits, "strawberry") -- also appends to end

print("\nAfter adding elements:")
for i = 1, #fruits do
    print(i, fruits[i])
end

-- Inserting an element at a specific position
table.insert(fruits, 3, "kiwi") -- insert at position 3

print("\nAfter inserting at position 3:")
for i = 1, #fruits do
    print(i, fruits[i])
end

-- Removing an element
table.remove(fruits, 5) -- remove element at index 5

print("\nAfter removing element at index 5:")
for i = 1, #fruits do
    print(i, fruits[i])
end

-- Iterating with ipairs (safe for arrays)
print("\nIterating with ipairs:")
for index, value in ipairs(fruits) do
    print(index, value)
end

-- Length operator in Lua (#)
print("\nArray length:", #fruits)

-- Accessing invalid index returns nil, not an error
print("\nAccessing index beyond array length:", fruits[100])

-- Warning: holes in arrays can cause issues with the length operator
fruits[20] = "dragon fruit"              -- creates a hole in the array
print("\nAfter creating a hole:")
print("Array apparent length:", #fruits) -- will not include the hole!

-- Checking specific elements
print("Element at index 20:", fruits[20]) -- exists despite not being counted in length

-- Creating an array with explicit indices
local sparse_array = {}
sparse_array[1] = "first"
sparse_array[5] = "fifth"
sparse_array[10] = "tenth"

print("\nSparse array elements:")
for k, v in pairs(sparse_array) do -- pairs works for sparse arrays
    print(k, v)
end

-- Using array functions with table library
local numbers = { 10, 20, 30, 40, 50 }
table.sort(numbers) -- sort in-place

print("\nSorted numbers:")
for i = 1, #numbers do
    print(i, numbers[i])
end

-- Concatenating array elements into string
local words = { "Lua", "tables", "are", "versatile" }
local sentence = table.concat(words, " ")
print("\nConcatenated string:", sentence)
