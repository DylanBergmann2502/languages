-- dictionaries.lua
-- Lua tables used as dictionaries/maps demonstration

-- In Lua, dictionaries are also implemented using tables
-- They use keys (of almost any type) to map to values

-- Creating a dictionary with string keys
local person = {
    name = "John",
    age = 30,
    occupation = "Developer",
    ["favorite color"] = "blue" -- When keys contain spaces, use square brackets
}

-- Printing dictionary contents
print("Person dictionary:")
for key, value in pairs(person) do
    print(key, value)
end

-- Accessing values by keys
print("\nAccessing specific values:")
print("Name:", person.name)                        -- Dot notation for simple keys
print("Age:", person["age"])                       -- Bracket notation works for all keys
print("Favorite color:", person["favorite color"]) -- Must use brackets for keys with spaces

-- Adding new key-value pairs
person.email = "john@example.com"
person["phone number"] = "555-123-4567"

print("\nAfter adding new entries:")
for key, value in pairs(person) do
    print(key, value)
end

-- Modifying values
person.age = 31
print("\nAfter modifying age:", person.age)

-- Removing a key-value pair
person.occupation = nil
print("\nAfter removing occupation:")
for key, value in pairs(person) do
    print(key, value)
end

-- Using different types as keys
local mixed_keys = {}
mixed_keys[1] = "Numeric key"
mixed_keys["string"] = "String key"
mixed_keys[true] = "Boolean key"
mixed_keys[person] = "Table key" -- Tables can be used as keys

local func = function() return "hello" end
mixed_keys[func] = "Function key"

print("\nMixed key types:")
for key, value in pairs(mixed_keys) do
    print(type(key), value)
end

-- Checking if a key exists
if person.name then
    print("\nPerson has a name:", person.name)
end

if not person.occupation then
    print("Person has no occupation")
end

-- Nested dictionaries
local company = {
    name = "Tech Solutions",
    employees = {
        ["001"] = { name = "Alice", department = "Engineering" },
        ["002"] = { name = "Bob", department = "Marketing" }
    },
    address = {
        street = "123 Tech St",
        city = "San Francisco",
        zipcode = "94105"
    }
}

print("\nAccessing nested dictionary values:")
print("Company name:", company.name)
print("First employee name:", company.employees["001"].name)
print("Company city:", company.address.city)

-- Using a dictionary as a set (values are ignored)
local unique_words = {}
local text = "the quick brown fox jumps over the lazy dog"
for word in string.gmatch(text, "%w+") do
    unique_words[word] = true
end

print("\nUnique words in text:")
for word, _ in pairs(unique_words) do
    print(word)
end

-- Common pattern: using tables as default values
local counts = {}
local wordCount = "the quick brown fox jumps over the lazy dog the fox"
for word in string.gmatch(wordCount, "%w+") do
    counts[word] = (counts[word] or 0) + 1
end

print("\nWord frequency:")
for word, count in pairs(counts) do
    print(word, count)
end
