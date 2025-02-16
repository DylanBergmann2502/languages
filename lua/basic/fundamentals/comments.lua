-- This is a single-line comment
print("After single line comment")

--[[
    This is a multi-line comment.
    You can write as many lines as you want.
    Useful for documentation or temporarily disabling code blocks.
]]

print("After multi-line comment")

-- You can use comments to explain code
local counter = 0 -- Initialize counter to 0

--[[
    More complex commenting example:
    Function: calculate_average
    Parameters:
        - numbers: table of numbers
    Returns:
        - average value
]]
local function calculate_average(numbers)
    local sum = 0
    for _, num in ipairs(numbers) do
        sum = sum + num
    end
    return sum / #numbers
end

--[=[
    This is a long comment delimiter.
    Useful when your comment contains regular
    comment syntax like: --[[ or ]]
]=]

-- Quick tricks:
---[[ Uncomment this block by adding one more '-'
print("This won't execute")
--]]

--[[
print("This is commented out")
--]]
