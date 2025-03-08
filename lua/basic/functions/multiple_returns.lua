-- multiple_returns.lua

-- Local function returning multiple values
local function get_person_info()
    return "Alex", 32, "Developer"
end

-- Capturing all returned values
local name, age, job = get_person_info()
print("Person:", name, age, job) -- Person: Alex 32 Developer

-- Capturing only some values
local first_name, years = get_person_info()
print("Partial info:", first_name, years) -- Partial info: Alex 32

-- Ignoring some values using underscore as placeholder
local _, _, occupation = get_person_info()
print("Just the job:", occupation) -- Just the job: Developer

-- Extra variables get nil
local n, a, j, extra = get_person_info()
print("Extra var:", extra) -- Extra var: nil

-- Function that returns variable number of results
local function find_in_table(t, value)
    for i, v in ipairs(t) do
        if v == value then
            return true, i -- Found: return true and position
        end
    end
    return false -- Not found: return just false
end

local fruits = { "apple", "banana", "orange", "grape" }
local found, position = find_in_table(fruits, "orange")
print("Found orange:", found, "at position", position) -- Found orange: true at position 3

found, position = find_in_table(fruits, "mango")
print("Found mango:", found, "at position", position) -- Found mango: false at position nil

-- Using multiple returns for success/error pattern
local function divide_safely(a, b)
    if b == 0 then
        return false, "Division by zero error"
    end
    return true, a / b
end

local success, result = divide_safely(10, 2)
if success then
    print("Division result:", result) -- Division result: 5
else
    print("Error:", result)
end

success, result = divide_safely(10, 0)
if success then
    print("Division result:", result)
else
    print("Error:", result) -- Error: Division by zero error
end

-- Using unpack/table.unpack with multiple returns
local function get_coordinates()
    return 10, 20, 30 -- x, y, z
end

local coords = { get_coordinates() }
print("Coordinates table:")
for i, v in ipairs(coords) do
    print(i, v)
end

-- Passing multiple returns to another function
local function calculate_volume(x, y, z)
    return x * y * z
end

-- Direct passing of multiple returns
local volume = calculate_volume(get_coordinates())
print("Volume:", volume) -- Volume: 6000
