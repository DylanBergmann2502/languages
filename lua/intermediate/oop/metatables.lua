-- metatables.lua
-- Metatables are Lua's way of customizing table behavior

-- Basic table
local t1 = { value = 5 }
local t2 = { value = 10 }

-- Simple addition without metatables would fail
-- print(t1 + t2) -- This would error: attempt to perform arithmetic on a table value

-- Let's create a metatable that defines how tables can be added
local mt = {
    -- __add is a metamethod that gets called when the + operator is used
    __add = function(a, b)
        return { value = a.value + b.value }
    end
}

-- Set the metatable for t1
setmetatable(t1, mt)

-- Now we can add tables!
local result = t1 + t2
print("t1 + t2 = " .. result.value) -- Output: t1 + t2 = 15

-- Other common metamethods
mt.__sub = function(a, b)
    return { value = a.value - b.value }
end

mt.__mul = function(a, b)
    return { value = a.value * b.value }
end

mt.__div = function(a, b)
    return { value = a.value / b.value }
end

-- String representation
mt.__tostring = function(obj)
    return "Box(" .. obj.value .. ")"
end

-- Now try other operations and printing
local sub_result = t1 - t2
local mul_result = t1 * t2
local div_result = t1 / t2

print("t1 - t2 = " .. sub_result.value) -- Output: t1 - t2 = -5
print("t1 * t2 = " .. mul_result.value) -- Output: t1 * t2 = 50
print("t1 / t2 = " .. div_result.value) -- Output: t1 / t2 = 0.5

-- With __tostring, we can print objects directly
print(t1) -- Output: Box(5)

-- Index and newindex metamethods
local prototype = {
    greet = function(self)
        return "Hello, " .. self.name
    end
}

local instance_mt = {
    -- __index defines what happens when accessing a missing key
    __index = prototype,

    -- __newindex defines what happens when setting a missing key
    __newindex = function(table, key, value)
        print("Setting new property: " .. key)
        rawset(table, key, value)
    end
}

local person = { name = "John" }
setmetatable(person, instance_mt)

-- Accessing a method from the prototype via __index
print(person:greet()) -- Output: Hello, John

-- Setting a new property will trigger __newindex
person.age = 30   -- Output: Setting new property: age
print(person.age) -- Output: 30

-- Table lookup with fallback
local defaults = { color = "blue", size = "medium", shape = "square" }
local options = { color = "red" }
setmetatable(options, { __index = defaults })

print(options.color) -- Output: red (from options)
print(options.size)  -- Output: medium (from defaults via __index)
print(options.shape) -- Output: square (from defaults via __index)

-- Call metamethod makes a table callable like a function
local callable = {}
setmetatable(callable, {
    __call = function(self, arg)
        return "You called me with: " .. arg
    end
})

print(callable("hello")) -- Output: You called me with: hello
