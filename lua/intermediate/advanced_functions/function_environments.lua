-- function_environments.lua

-- In Lua, functions have an associated environment table
-- This environment determines where global variables are stored and looked up
-- Prior to Lua 5.2, this was controlled by the function's "env" field (_ENV was introduced in 5.2)

-- Let's explore function environments in Lua 5.2+ with _ENV

-- 1. The global environment
print("Current value of x in global environment:", x) -- nil, not defined yet

x = 10                                                -- Define a global variable
print("Now x =", x)                                   -- 10

-- 2. Creating a custom environment
local my_env = {
    print = print, -- Import the print function from the global environment
    x = 20         -- Define our own x in this environment
}

-- 3. Using _ENV to change the environment for a chunk of code
local function test_env()
    local _ENV = my_env                        -- Set environment for this block
    print("Inside custom environment, x =", x) -- Will use x from my_env

    x = 30                                     -- Modifies x in my_env
    print("After modification, x =", x)
end

test_env()

-- The global x is unchanged
print("Global x is still:", x) -- 10

-- But my_env.x was changed
print("my_env.x is now:", my_env.x) -- 30

-- 4. Function factories with custom environments
local function create_counter(start_value)
    local env = {
        count = start_value or 0,
        print = print
    }

    -- Define function with custom environment
    local function counter()
        local _ENV = env
        count = count + 1
        print("Counter value:", count)
        return count
    end

    return counter
end

local counter1 = create_counter(5)
local counter2 = create_counter(100)

counter1() -- 6
counter1() -- 7
counter2() -- 101
counter1() -- 8

-- 5. The traditional approach (Lua 5.1 style) with setfenv
-- Note: setfenv is deprecated in Lua 5.2+ but understanding it helps with legacy code
if _VERSION == "Lua 5.1" then
    print("\nLua 5.1 environment demonstration:")

    function old_style_func()
        print("Inside function, x =", x)
    end

    -- In Lua 5.1, you would do:
    local old_env = { x = 50, print = print }
    setfenv(old_style_func, old_env)

    old_style_func() -- Would print 50 in Lua 5.1
else
    print("\nRunning in Lua " .. _VERSION .. ", skipping setfenv example")
end

-- 6. Practical use case: Sandboxing code execution
local function create_sandbox()
    -- Create a restricted environment with limited functions
    local sandbox_env = {
        print = print,
        type = type,
        tostring = tostring,
        tonumber = tonumber,
        math = {
            abs = math.abs,
            max = math.max,
            min = math.min
        }
    }

    -- Function to execute code in the sandbox
    local function run_in_sandbox(code)
        -- Create a function from the code with the sandbox environment
        local func, err = load("return " .. code, "sandbox", "t", sandbox_env)
        if not func then
            -- Try without "return" for statements
            func, err = load(code, "sandbox", "t", sandbox_env)
        end

        if not func then
            return nil, "Compilation error: " .. tostring(err)
        end

        -- Execute the function in the sandbox
        local success, result = pcall(func)
        if not success then
            return nil, "Runtime error: " .. tostring(result)
        end

        return result
    end

    return run_in_sandbox
end

local sandbox = create_sandbox()

-- Safe code execution in sandbox
print("\nSandbox tests:")
print("1 + 1 =", sandbox("1 + 1"))
print("math.max(5, 10) =", sandbox("math.max(5, 10)"))

-- Attempt to access restricted functionality
local result, err = sandbox("os.execute('dir')")
print("Attempt to use os.execute:", result or err)
