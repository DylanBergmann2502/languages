-- Variable declaration in Lua
-- By default, variables are global unless declared with 'local'
local age = 25         -- Number
local name = "Claude"  -- String
local is_active = true -- Boolean
local data = nil       -- Nil (similar to Python's None)

-- Global variable (not recommended, but shown for demonstration)
global_var = "I am global"

-- Multiple assignment
local x, y = 10, 20

-- Variable scope demonstration
do
    local scope_var = "I am local to this block"
    print(scope_var) -- Available here
end
-- print(scope_var)  -- This would error - scope_var not available here

-- Variables are dynamically typed
local dynamic = 10
print(type(dynamic)) -- "number"
dynamic = "string now"
print(type(dynamic)) -- "string"

-- Number variables can be integers or floats
local int_num = 42
local float_num = 42.5

-- String can use single or double quotes
local str1 = 'single quotes'
local str2 = "double quotes"

-- Print everything to see the results
print("age:", age)
print("name:", name)
print("is_active:", is_active)
print("data:", data)
print("global_var:", global_var)
print("x:", x, "y:", y)
print("int_num:", int_num)
print("float_num:", float_num)
print("str1:", str1)
print("str2:", str2)
