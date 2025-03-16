-- requiring_modules.lua

-- This module demonstrates how to require/load other modules in Lua

local requiring_modules = {}

-- Basic require syntax
function requiring_modules.basic_require()
    -- You can require modules by name, which Lua will search for in its package.path
    local module1 = require("creating_modules")
    return "Loaded module version: " .. module1.version
end

-- Storing the result in a local variable with a different name
function requiring_modules.renamed_require()
    local renamed = require("creating_modules")
    return renamed.greet("from renamed require")
end

-- Require is cached - calling it multiple times returns the same instance
function requiring_modules.demonstrate_caching()
    local first = require("creating_modules")
    local second = require("creating_modules")

    -- Let's prove they're the same table
    first.custom_value = "This value was added at runtime"

    return "Second instance has custom_value: " .. (second.custom_value or "nil")
end

-- You can also require modules from subdirectories using dots
function requiring_modules.from_subdirectory()
    -- This would try to require a module from 'subdirectory/some_module.lua'
    -- local submodule = require("subdirectory.some_module")
    return "To require from subdirectory, use: require('subdirectory.module_name')"
end

return requiring_modules
