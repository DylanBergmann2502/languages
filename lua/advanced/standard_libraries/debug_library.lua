-- debug_library.lua
-- Exploring Lua's debug library

-- Print a separator line for better readability
local function separator()
    print("\n" .. string.rep("-", 50) .. "\n")
end

print("WARNING: The debug library provides access to internal features of Lua")
print("It's primarily intended for debugging tools and should be used with caution")
print("in production code as it can violate encapsulation and impact performance.")

separator()

-- Getting information about a function
print("Function Information:")

-- Define a sample function to inspect
local function sample_function(a, b, c)
    local x = 10
    local y = 20
    return a + b + c + x + y
end

-- Get debug info about our function
local info = debug.getinfo(sample_function)
print("Function info:")
for k, v in pairs(info) do
    print("  " .. k .. ":", v)
end

-- More detailed info with different what parameter
-- In Lua 5.4, we'll use standard options: 'n' (name), 'S' (source), 'l' (line)
local detailed_info = debug.getinfo(sample_function, "nSl")
print("\nDetailed function info:")
print("  Name:", detailed_info.name or "anonymous")
print("  What:", detailed_info.what) -- Lua, C, main, tail
print("  Source:", detailed_info.source)
print("  Short source:", detailed_info.short_src)
print("  Line defined:", detailed_info.linedefined)
print("  Last line defined:", detailed_info.lastlinedefined)
print("  Number of upvalues:", detailed_info.nups)

separator()

-- Examining the call stack
print("Call Stack Information:")

-- Create a nested function structure to demonstrate call stack
local function level3()
    print("Call stack from level3:")
    for i = 0, 3 do
        local info = debug.getinfo(i)
        if info then
            print("  Level " .. i .. ":", info.name or "?", info.what, info.source, "line",
                info.currentline or info.linedefined)
        else
            print("  Level " .. i .. ": No information available")
        end
    end
end

local function level2()
    level3()
end

local function level1()
    level2()
end

-- Call the nested functions
level1()

separator()

-- Local variables inspection
print("Local Variables Inspection:")

-- Function with locals to inspect
local function locals_demo(param1, param2)
    local var1 = "hello"
    local var2 = 42

    -- Print local variables at this level
    local level = 1
    print("Local variables at level", level, "(locals_demo):")
    local i = 1
    while true do
        local name, value = debug.getlocal(level, i)
        if not name then break end
        print("  " .. i .. ":", name, "=", value)
        i = i + 1
    end

    return var1 .. " " .. var2
end

locals_demo("test", 123)

separator()

-- Upvalues inspection
print("Upvalues Inspection:")

local outer_var = "I'm from outer scope"

local function upvalues_demo()
    local inner_var = "I'm from inner scope"

    local function inner_function()
        print("Using upvalues:", outer_var, inner_var)
    end

    -- Inspect upvalues of inner_function
    print("Upvalues of inner_function:")
    local i = 1
    while true do
        local name, value = debug.getupvalue(inner_function, i)
        if not name then break end
        print("  " .. i .. ":", name, "=", value)
        i = i + 1
    end

    return inner_function
end

local closure = upvalues_demo()

separator()

-- Modifying variables with debug library
print("Modifying Variables:")

local function modify_demo()
    local test_var = "original value"

    print("Before modification:", test_var)

    -- Self-modification: find our own 'test_var' and change it
    local level = 1
    local i = 1
    while true do
        local name, value = debug.getlocal(level, i)
        if not name then break end
        if name == "test_var" then
            debug.setlocal(level, i, "modified value")
            print("  Modified local variable", name)
        end
        i = i + 1
    end

    print("After modification:", test_var)
end

modify_demo()

-- Modify upvalues demonstration
local function modify_upvalue_demo()
    local encapsulated = "private data"

    local function get_data()
        return encapsulated
    end

    local function set_data(new_value)
        encapsulated = new_value
    end

    print("Original encapsulated value:", get_data())

    -- Use debug to modify the upvalue directly, bypassing the setter
    local name, value = debug.getupvalue(get_data, 1)
    print("Found upvalue:", name, "=", value)
    debug.setupvalue(get_data, 1, "modified directly")

    print("After direct modification:", get_data())

    return get_data, set_data
end

local getter, setter = modify_upvalue_demo()

separator()

-- Hooks demonstration
print("Debug Hooks:")
print("Hooks allow you to register functions that Lua calls on certain events")
print("Note: This example will turn on hooks briefly and then disable them")

local hook_count = 0
local max_hooks = 10

local function hook_function(event, line)
    hook_count = hook_count + 1
    print("Hook #" .. hook_count .. " - Event: " .. event ..
        (event == "line" and " (line " .. line .. ")" or ""))

    -- Disable hook after max calls to prevent flooding the console
    if hook_count >= max_hooks then
        debug.sethook()
        print("Hooks disabled after " .. max_hooks .. " calls")
    end
end

-- Set a hook for line events, called every 2 lines
print("Setting line hook...")
debug.sethook(hook_function, "l", 2)

-- Run some code to trigger hooks
local function trigger_hooks()
    local a = 1
    local b = 2
    local c = 3
    local d = 4
    local e = 5
    for i = 1, 5 do
        a = a + i
    end
    return a
end

local result = trigger_hooks()
print("Function result:", result)

-- Make sure hook is disabled
debug.sethook()

separator()

-- Debug library utility functions
print("Debug Utility Functions:")

-- debug.traceback
print("\ndebug.traceback() - Generate a stack trace:")
local trace = debug.traceback("Custom error message", 2)
print(trace)

-- debug.debug - Interactive debugging console (commented out to prevent script from stopping)
print("\ndebug.debug() - Interactive debugging console:")
print("  This function starts an interactive console")
print("  Not running it here to avoid interrupting the script")
-- Uncomment this line to try it: debug.debug()

separator()

print("Safe Use of Debug Library:")
print("1. Limit debug library in production code")
print("2. Consider wrapping debug functions in pcall() for safety")
print("3. Be aware of performance overhead")
print("4. Remember that the debug interface might change between Lua versions")
