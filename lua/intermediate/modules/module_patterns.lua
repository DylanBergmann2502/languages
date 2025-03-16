-- module_patterns.lua

-- This module demonstrates different patterns for creating Lua modules

-- Pattern 1: Simple table return (most common)
local function create_simple_module()
    local module = {}

    module.name = "Simple Module"

    function module.say_hello()
        return "Hello from " .. module.name
    end

    return module
end

-- Pattern 2: Function call pattern
local function create_function_call_module()
    local module = {}

    module.name = "Function Call Module"

    function module.say_hello()
        return "Hello from " .. module.name
    end

    -- Return a function that returns the module
    return function()
        return module
    end
end

-- Pattern 3: Module with privacy using closures
local function create_private_module()
    local module = {}

    -- Private variables
    local private_value = "secret data"

    function module.get_private_data()
        return "Accessing: " .. private_value
    end

    function module.set_private_data(new_value)
        private_value = new_value
        return "Private data updated"
    end

    return module
end

-- Expose the module creation patterns
local module_patterns = {
    simple_module = create_simple_module(),
    function_call_module = create_function_call_module(),
    private_module = create_private_module(),

    -- Helper function to demonstrate the patterns
    demonstrate = function()
        local results = {}

        -- Simple module pattern
        local simple = create_simple_module()
        table.insert(results, simple.say_hello())

        -- Function call pattern - need to call it to get the module
        local func_module = create_function_call_module()()
        table.insert(results, func_module.say_hello())

        -- Private module pattern
        local private = create_private_module()
        table.insert(results, private.get_private_data())
        private.set_private_data("updated secret")
        table.insert(results, private.get_private_data())

        return table.concat(results, "\n")
    end
}

return module_patterns
