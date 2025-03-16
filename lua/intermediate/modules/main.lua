-- main.lua
-- This file demonstrates how to use all of our module files

print("==== DEMONSTRATING MODULES IN LUA ====")
print()

-- Load the creating_modules.lua module
print("Loading creating_modules.lua...")
local creator = require("creating_modules")
print("Greeting: " .. creator.greet("Lua Learner"))
print("Addition: " .. creator.add(10, 32))
print("Module version: " .. creator.version)
print()

-- Load and demonstrate requiring_modules.lua
print("Loading requiring_modules.lua...")
local requirer = require("requiring_modules")
print(requirer.basic_require())
print(requirer.renamed_require())
print(requirer.demonstrate_caching())
print(requirer.from_subdirectory())
print()

-- Load and demonstrate module_patterns.lua
print("Loading module_patterns.lua...")
local patterns = require("module_patterns")
print("Simple module: " .. patterns.simple_module.say_hello())
print("Function call module: " .. patterns.function_call_module().say_hello())
print("Private module: " .. patterns.private_module.get_private_data())

print("\nDemonstrating all patterns:")
print(patterns.demonstrate())
print()

-- Load and demonstrate package_path.lua
print("Loading package_path.lua...")
local paths = require("package_path")
print(paths.show_package_path())
print()
print("Package path explanation:")
print(paths.explain_package_path())
print()
print("Module search order:")
print(paths.module_search_order())
print()

-- Add a custom path as demonstration
print("Adding custom path './custom/?.lua'...")
paths.add_path("./custom/?.lua")
print()

print("==== MODULE DEMONSTRATION COMPLETE ====")
