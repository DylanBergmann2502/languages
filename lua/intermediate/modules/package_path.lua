-- package_path.lua

-- This module demonstrates how Lua's package.path works for finding modules

local package_path_module = {}

function package_path_module.show_package_path()
    return "Current package.path: " .. package.path
end

function package_path_module.explain_package_path()
    local explanation = {
        "package.path is a string containing paths where Lua looks for modules.",
        "Each path is separated by semicolons (;).",
        "The question mark (?) in each path is replaced by the module name.",
        "For example, if you require('foo'), Lua will look for:",
        "  - foo.lua in the current directory",
        "  - foo.lua in the directories specified in package.path"
    }

    return table.concat(explanation, "\n")
end

function package_path_module.add_path(new_path)
    -- Add a new path to package.path
    package.path = package.path .. ";" .. new_path
    return "Path added. New package.path: " .. package.path
end

function package_path_module.module_search_order()
    local explanation = {
        "When you call require('module_name'), Lua searches in this order:",
        "1. Checks if the module is already loaded in package.loaded",
        "2. Checks for a C loader in package.preload",
        "3. Tries to find a Lua file using package.path",
        "4. Tries to find a C library using package.cpath",
        "5. If nothing found, throws an error"
    }

    return table.concat(explanation, "\n")
end

return package_path_module
