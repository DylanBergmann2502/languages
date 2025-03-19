-- string_patterns.lua
-- Demonstrates Lua's pattern matching capabilities

-- Lua uses its own pattern matching syntax, not regular expressions
print("=== Basic Patterns ===")

-- Basic character matching
local text = "Hello Lua patterns!"
print(string.find(text, "Lua")) -- 7 9 (start and end positions)

-- Character classes with %
-- %a: letters, %d: digits, %s: whitespace, %p: punctuation
local has_digits = string.match("Testing 123", "%d+")
print("Digits found:", has_digits) -- 123

-- Character sets with []
local vowels = string.gsub("Hello World", "[aeiou]", "*")
print("Replace vowels:", vowels) -- H*ll* W*rld

print("\n=== Pattern Modifiers ===")

-- Modifiers:
-- +: 1 or more repetitions
-- *: 0 or more repetitions
-- -: 0 or more repetitions (minimal)
-- ?: optional (0 or 1 occurrence)

-- Match all digits with %d+
local phone = "Call me at 555-123-4567 please."
local number = string.match(phone, "%d+-%d+-%d+")
print("Phone number:", number) -- 555-123-4567

-- . matches any character except newline
local wildcard = string.match("abc123", "a..")
print("Wildcard match:", wildcard) -- abc

print("\n=== Capture Groups ===")

-- Capture with ()
local date = "Today is 2025-03-19"
local year, month, day = string.match(date, "(%d+)-(%d+)-(%d+)")
print("Date components:", year, month, day) -- 2025 03 19

-- Named captures (Lua 5.4+)
if _VERSION >= "Lua 5.4" then
    local data = "Name: John, Age: 30"
    local pattern = "Name: (%a+), Age: (%d+)"
    local name, age = string.match(data, pattern)
    print("Person info:", name, age) -- John 30
end

print("\n=== Pattern Functions ===")

-- string.find - find position of pattern
local s, e = string.find("Hello Lua World", "Lua")
print("'Lua' found at positions:", s, e) -- 7 9

-- string.match - extract first match
local extracted = string.match("Email: john@example.com", "%a+@[%a%.]+")
print("Extracted email:", extracted) -- john@example.com

-- string.gmatch - iterator for all matches
print("Words in sentence:")
for word in string.gmatch("The quick brown fox jumps over the lazy dog", "%a+") do
    print("  -", word)
end

-- string.gsub - global substitution
local censored = string.gsub("I hate broccoli and spinach", "hate", "love")
print("Replaced text:", censored) -- I love broccoli and spinach

print("\n=== Practical Examples ===")

-- Example 1: Extract domain from URL
local url = "https://www.example.com/path/to/page.html"
local domain = string.match(url, "https?://([^/]+)")
print("Domain:", domain) -- www.example.com

-- Example 2: Validate simple email format
local function is_valid_email(email)
    return string.match(email, "^%a[%w%.]*@%a[%w%.]+%.%a%a+$") ~= nil
end

print("Email validation:")
print("  test@example.com -", is_valid_email("test@example.com"))
print("  invalid@email -", is_valid_email("invalid@email"))

-- Example 3: Parse CSV line
local function parse_csv(line)
    local items = {}
    for item in string.gmatch(line, "([^,]+)") do
        table.insert(items, item)
    end
    return items
end

local csv_line = "apple,orange,banana,grape"
local fruits = parse_csv(csv_line)
print("CSV items:")
for i, fruit in ipairs(fruits) do
    print("  " .. i .. ":", fruit)
end

-- Example 4: Format numbers with thousand separators
local function format_number(num)
    local formatted = tostring(num)
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then break end
    end
    return formatted
end

print("Formatted number:", format_number(1234567)) -- 1,234,567
