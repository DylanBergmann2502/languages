-- pattern_matching_advanced.lua
-- Advanced pattern matching techniques in Lua

print("=== Advanced Pattern Techniques ===")

-- Balanced matching with %b
-- %bxy matches string starting with x, ending with y with balanced content
local str = "function add(a, b) return a + b end"
local body = string.match(str, "function%s+%w+%(%a, %a%)%s+(.+)%s+end")
print("Function body:", body) -- return a + b

-- Balanced parentheses
local expr = "(3 + 4) * (5 - 2)"
local first_group = string.match(expr, "%b()")
print("First balanced group:", first_group) -- (3 + 4)

print("\n=== Non-Greedy Patterns ===")

-- Non-greedy matching with %-
local html = "<div><p>First paragraph</p><p>Second paragraph</p></div>"

-- Greedy match (captures everything between first and last tags)
local greedy = string.match(html, "<p>(.+)</p>")
print("Greedy match:", greedy) -- First paragraph</p><p>Second paragraph

-- Non-greedy match (captures minimally between tags)
local non_greedy = string.match(html, "<p>(.-)</p>")
print("Non-greedy match:", non_greedy) -- First paragraph

print("\n=== Frontier Patterns ===")

-- Frontier pattern for word boundaries (emulating \b in regex)
local function word_boundary(pattern)
    -- Match at start, between word/non-word, or at end
    return "%f[%a]" .. pattern .. "%f[^%a]"
end

local text = "The cat scattered the caterpillar on the catalog"

-- Find whole word "cat" only
local count = 0
for _ in string.gmatch(text, word_boundary("cat")) do
    count = count + 1
end
print("Occurrences of whole word 'cat':", count) -- 1

print("\n=== Multi-line Patterns ===")

local multiline = [[
First line
Second line with a number: 123
Third line with email: test@example.com
Last line
]]

-- Match across multiple lines (DOT_ALL equivalent)
local function match_all(text, pattern)
    -- Replace newlines with temporary marker
    local temp_marker = "\0"
    local transformed = string.gsub(text, "\n", temp_marker)
    local result = string.match(transformed, pattern)
    if result then
        -- Restore newlines in result
        return string.gsub(result, temp_marker, "\n")
    end
    return nil
end

local extracted = match_all(multiline, "Second line.+email: (.+)Last")
print("Extracted across lines:", extracted) -- test@example.com\n

print("\n=== Pattern Anchors ===")

-- ^ anchors to beginning, $ anchors to end
local starts_with_the = string.match("The quick brown fox", "^The")
print("Starts with 'The':", starts_with_the ~= nil) -- true

local ends_with_dot = string.match("This is a sentence.", "%.$")
print("Ends with period:", ends_with_dot ~= nil) -- true

print("\n=== Look-around Emulation ===")

-- Emulating positive lookahead
local function followed_by(text, pattern, lookahead)
    local s, e = string.find(text, pattern)
    if s then
        local after = string.sub(text, e + 1)
        if string.find(after, "^" .. lookahead) then
            return string.sub(text, s, e)
        end
    end
    return nil
end

-- Find numbers followed by "px"
local css = "width: 100px; height: 200em; margin: 10px;"
local width = followed_by(css, "%d+", "px")
print("First value in px:", width) -- 100

print("\n=== Custom Pattern Functions ===")

-- Split string function (not built into Lua)
local function split(str, pattern)
    local result = {}
    local start = 1
    local split_start, split_end = string.find(str, pattern, start)

    while split_start do
        table.insert(result, string.sub(str, start, split_start - 1))
        start = split_end + 1
        split_start, split_end = string.find(str, pattern, start)
    end

    table.insert(result, string.sub(str, start))
    return result
end

local sentence = "The quick brown fox jumps over the lazy dog"
local words = split(sentence, " ")
print("Word count:", #words) -- 9

-- Create a pattern to match specific format
local function create_date_pattern(format)
    -- Convert common format tokens to Lua patterns directly
    local pattern = format
    pattern = string.gsub(pattern, "yyyy", "(%%d%%d%%d%%d)")
    pattern = string.gsub(pattern, "mm", "(%%d%%d)")
    pattern = string.gsub(pattern, "dd", "(%%d%%d)")
    
    return pattern
end

local date_str = "2025-03-19"
local date_pattern = create_date_pattern("yyyy-mm-dd")
local year, month, day = string.match(date_str, date_pattern)
print("Parsed date:", year, month, day) -- 2025 03 19

print("\n=== Advanced Capture Usage ===")

-- Named captures emulation (for Lua < 5.4)
local function extract_named(text, pattern)
    local names = {}
    local capture_pattern = ""

    for name, capture in string.gmatch(pattern, "(%w+):([^;]+);") do
        table.insert(names, name)
        capture_pattern = capture_pattern .. capture
    end

    local results = { string.match(text, capture_pattern) }
    local named_results = {}

    for i, name in ipairs(names) do
        named_results[name] = results[i]
    end

    return named_results
end

local user_data = "John Doe, 30 years old, New York"
local captures = extract_named(
    user_data,
    "name:([%a ]+), ;age:(%d+);location:([%a ]+)$;"
)

print("Named captures:")
for name, value in pairs(captures) do
    print("  " .. name .. ":", value)
end
