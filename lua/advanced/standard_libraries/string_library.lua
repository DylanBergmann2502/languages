-- string_library.lua
-- Exploring Lua's string library

-- Print a separator line for better readability
local function separator()
    print("\n" .. string.rep("-", 50) .. "\n")
end

-- Basic string length
print("String length with #")
local str = "Hello, Lua!"
print("#str:", #str)
print("string.len(str):", string.len(str))

separator()

-- String repetition
print("String repetition")
print(string.rep("abc", 3))
print(string.rep("*", 10))

separator()

-- Case conversion
print("Case conversion")
print(string.upper("hello"))
print(string.lower("WORLD"))

separator()

-- Character codes (ASCII/Unicode)
print("Character codes")
print("ASCII code for 'A':", string.byte("A"))
print("ASCII code for 'a':", string.byte("a"))
print("Character for code 65:", string.char(65))
print("Multiple characters:", string.char(72, 101, 108, 108, 111)) -- "Hello"

separator()

-- Substring extraction
print("Substring extraction")
local message = "Lua is powerful"
print(string.sub(message, 1, 3))   -- First 3 characters
print(string.sub(message, 5))      -- From 5th character to end
print(string.sub(message, -8))     -- Last 8 characters
print(string.sub(message, -9, -5)) -- Characters between positions from end

separator()

-- String formatting
print("String formatting")
local name = "Lua"
local version = 5.4
local formatted = string.format("Language: %s, Version: %.1f", name, version)
print(formatted)

print("Formatting specifiers:")
print(string.format("Integer: %d", 42))
print(string.format("Float: %f", 3.14159))
print(string.format("Float (rounded): %.2f", 3.14159))
print(string.format("Hex: %x", 255))
print(string.format("Padding: %05d", 42))
print(string.format("Left-aligned: %-10s!", "Lua"))

separator()

-- String find (basic)
print("String find")
local text = "The quick brown fox jumps over the lazy dog"
local start_pos, end_pos = string.find(text, "fox")
print("'fox' found at positions:", start_pos, "to", end_pos)

-- Find with plain text search (no pattern matching)
start_pos, end_pos = string.find(text, ".", 1, true) -- 4th arg 'true' means plain search
print("'.' found at positions:", start_pos, "to", end_pos)

separator()

-- String pattern matching
print("Pattern matching with find")
-- Find a word boundary with %w (word character) and %s (space)
start_pos, end_pos = string.find(text, "%w+%s%w+")
print("First two words found at:", start_pos, "to", end_pos)
print("Text:", string.sub(text, start_pos, end_pos))

separator()

-- String matching (returns captures)
print("String match")
local match = string.match(text, "(%w+)%s(%w+)%s(%w+)")
print("First three words:", match)

-- Multiple captures
local first, second, third = string.match(text, "(%w+)%s(%w+)%s(%w+)")
print("Words separately:", first, second, third)

separator()

-- String replacement
print("String replacement (gsub)")
local result, count = string.gsub(text, "the", "a")
print("After replacing 'the':", result)
print("Number of replacements:", count)

-- Using patterns in replacement
result, count = string.gsub(text, "%a+", function(word)
    if #word > 4 then
        return word:upper()
    else
        return word
    end
end)
print("Words longer than 4 characters capitalized:", result)

separator()

-- String reverse
print("String reverse")
print(string.reverse("Hello Lua"))

separator()

-- String gmatch (global match) for iterating over patterns
print("String gmatch - iterating over patterns")
print("Words in the sentence:")
for word in string.gmatch(text, "%a+") do
    print("  -", word)
end

separator()

-- Pattern reference
print("Lua Pattern Reference:")
print("  . : any character")
print("  %a: letters")
print("  %d: digits")
print("  %w: alphanumeric")
print("  %s: whitespace")
print("  %p: punctuation")
print("  %c: control characters")
print("  %l: lowercase letters")
print("  %u: uppercase letters")
print("  %z: null character")
print("  [set]: any character in set")
print("  [^set]: any character not in set")

-- Examples of patterns
print("\nPattern examples:")
local test_string = "Test123, testing!"
print("Original:", test_string)
print("All letters:", string.gsub(test_string, "%a+", "X"))
print("All digits:", string.gsub(test_string, "%d+", "Y"))
print("Words:", string.gsub(test_string, "%w+", "Z"))
