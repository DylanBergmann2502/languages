-- goto.lua

-- `goto` is a control flow statement that 
-- lets you jump to a labeled section of code. 
-- Think of it like placing bookmarks (labels) 
-- in your code and being able to jump to those bookmarks.

-- However, `goto` comes with restrictions:
-- Can't jump into a block (like inside a function or loop)
-- Can't jump across function boundaries
-- Labels must be in the same scope as the goto

-- Most Lua developers avoid goto because:
-- It can make code harder to follow
-- It's often better to use functions, returns, or restructure loops
-- The main legitimate use case is breaking out of multiple nested loops.


-- Basic goto example
local i = 1
::start::  -- This is a label
if i <= 3 then
    print("Count: " .. i)
    i = i + 1
    goto start
end

-- Error handling pattern (outside function)
print("\nError handling example:")
local value = "not a number"  -- test value

::check_type::
if type(value) ~= "number" then
    print("Error: Not a number")
    goto done
end

::check_negative::
if value < 0 then
    print("Error: Negative number")
    goto done
end

print("Processing:", value)
goto done

::done::

-- Breaking nested loops example
print("\nBreaking nested loops:")
for i = 1, 3 do
    for j = 1, 3 do
        if i * j > 4 then
            goto exit_loops  -- breaks out of both loops
        end
        print(i .. "x" .. j .. "=" .. i*j)
    end
end
::exit_loops::

-- Simple state machine example
print("\nState machine example:")
local state = "start"
local count = 0

::state_start::
if state == "start" then
    print("Starting...")
    state = "running"
    goto state_running
end

::state_running::
if state == "running" then
    count = count + 1
    print("Running... count:", count)
    if count >= 3 then
        state = "end"
        goto state_end
    end
    goto state_running
end

::state_end::
if state == "end" then
    print("Finished!")
end

-- Example of what NOT to do (commented out as it would cause errors):
--[[
local function bad_function()
    ::label_inside::  -- This is NOT allowed!
    print("This won't work")
end
--]]

print("\nScript completed!")