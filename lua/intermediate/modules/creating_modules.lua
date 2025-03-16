-- creating_modules.lua

-- In Lua, a module is typically a table containing functions and variables
-- The simplest way to create a module is to define a table and return it

local my_module = {}

-- Add some functions to our module
function my_module.greet(name)
    return "Hello, " .. name .. "!"
end

function my_module.add(a, b)
    return a + b
end

-- Add some variables/constants to our module
my_module.version = "1.0.0"
my_module.author = "Your Name"

-- You can also add "private" functions that aren't exposed
local function internal_helper()
    return "I'm a helper function not exposed directly"
end

-- A function that uses the internal helper
function my_module.do_something_complex()
    local result = internal_helper()
    return result .. " but I'm accessible through a public method!"
end

-- The module pattern in Lua is to return the module table at the end of the file
return my_module
