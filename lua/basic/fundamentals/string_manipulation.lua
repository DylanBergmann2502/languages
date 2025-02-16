print("=== Basic String Operations ===")
local str = "Hello, World!"
print("Original string: " .. str)
print("Length: " .. #str)                 -- 13
print("Uppercase: " .. string.upper(str)) -- HELLO, WORLD!
print("Lowercase: " .. string.lower(str)) -- hello, world!

print("\n=== String Concatenation ===")
local first = "Hello"
local second = "World"
-- Using concatenation operator
print(first .. " " .. second)                -- Hello World
-- Using string.format
print(string.format("%s %s", first, second)) -- Hello World

print("\n=== Substring Operations ===")
local text = "Lua Programming"
-- string.sub(str, start_index, end_index)
-- Indices start at 1 in Lua!
print(string.sub(text, 1, 3)) -- Lua
print(string.sub(text, 5))    -- Programming
print(string.sub(text, -11))  -- Programming (negative index counts from end)

print("\n=== String Patterns and Replace ===")
local sentence = "The quick brown fox"
-- string.gsub(str, pattern, replacement, [max_replacements])
local result, count = string.gsub(sentence, "quick", "slow")
print(string.format("Modified: %s (replacements: %d)", result, count)) -- The slow brown fox (1)

print("\n=== Pattern Matching ===")
local text2 = "Age: 25, Code: ABC-123"
-- Find numbers
local number = string.match(text2, "%d+")
print("First number found: " .. number) -- 25

-- Find all numbers
print("\nAll numbers:")
for num in string.gmatch(text2, "%d+") do
    print(num) -- 25, 123
end

print("\n=== String Find ===")
local text3 = "Hello, World!"
local start, end_pos = string.find(text3, "World")
print(string.format("'World' found at positions %d to %d", start, end_pos)) -- 8 to 12

print("\n=== String Patterns Examples ===")
print("\nPattern matching examples:")
local test_string = "Test123@example.com"
print("Original: " .. test_string)
-- Find letters
print("Letters: " .. string.match(test_string, "%a+"))    -- Test
-- Find digits
print("Digits: " .. string.match(test_string, "%d+"))     -- 123
-- Find word characters (letters, digits, underscores)
print("Word chars: " .. string.match(test_string, "%w+")) -- Test123

print("\n=== String Formatting ===")
-- Various format specifiers
local name = "Lua"
local version = 5.4
local score = 98.6
print(string.format("Name: %s", name))         -- Name: Lua
print(string.format("Version: %.1f", version)) -- Version: 5.4
print(string.format("Score: %06.2f", score))   -- Score: 098.60
print(string.format("Hex: %X", 255))           -- Hex: FF
print(string.format("Padded: %10s", name))     -- Padded:        Lua

print("\n=== String Reverse ===")
local text4 = "Lua"
print("Reversed: " .. string.reverse(text4)) -- auL

print("\n=== String Repetition ===")
local char = "="
print(string.rep(char, 10)) -- ==========
