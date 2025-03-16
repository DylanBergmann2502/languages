-- metamethods.lua
-- Metamethods give us control over table behavior for various operations

-- Create a simple vector implementation
local Vector = {}
Vector.__index = Vector -- Makes Vector able to serve as a metatable for itself

-- Constructor
function Vector.new(x, y)
    local vec = { x = x or 0, y = y or 0 }
    return setmetatable(vec, Vector)
end

-- Arithmetic metamethods
Vector.__add = function(a, b)
    -- Allow vector + vector
    return Vector.new(a.x + b.x, a.y + b.y)
end

Vector.__sub = function(a, b)
    -- Allow vector - vector
    return Vector.new(a.x - b.x, a.y - b.y)
end

Vector.__mul = function(a, b)
    if type(a) == "number" then
        -- Allow scalar * vector
        return Vector.new(a * b.x, a * b.y)
    elseif type(b) == "number" then
        -- Allow vector * scalar
        return Vector.new(a.x * b, a.y * b)
    else
        -- Allow vector * vector (dot product)
        return a.x * b.x + a.y * b.y
    end
end

Vector.__div = function(a, b)
    -- Allow vector / scalar
    if type(b) == "number" then
        return Vector.new(a.x / b, a.y / b)
    else
        error("Division: right operand must be a number")
    end
end

-- Unary minus
Vector.__unm = function(v)
    -- Allow -vector
    return Vector.new(-v.x, -v.y)
end

-- Equality comparison
Vector.__eq = function(a, b)
    -- Allow vector == vector
    return a.x == b.x and a.y == b.y
end

-- Length operator (#)
Vector.__len = function(v)
    -- Allow #vector to get magnitude
    return math.sqrt(v.x * v.x + v.y * v.y)
end

-- String representation
Vector.__tostring = function(v)
    -- Allow print(vector)
    return "Vector(" .. v.x .. ", " .. v.y .. ")"
end

-- Methods
function Vector:magnitude()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector:normalize()
    local mag = self:magnitude()
    if mag > 0 then
        return self / mag
    else
        return Vector.new(0, 0)
    end
end

-- Need to set Vector as its own metatable to enable __call
setmetatable(Vector, {
    __call = function(class, x, y)
        -- Allow Vector(x, y) as shorthand for Vector.new(x, y)
        return Vector.new(x, y)
    end
})

-- Create some vectors to test our metamethods
local v1 = Vector.new(3, 4)
local v2 = Vector.new(1, 2)
local v3 = Vector(5, 6) -- Now this will work with __call metamethod

-- Test arithmetic operations
print("v1:", v1)           -- Uses __tostring
print("v2:", v2)
print("v3:", v3)           -- This should work now
print("v1 + v2:", v1 + v2) -- Uses __add
print("v1 - v2:", v1 - v2) -- Uses __sub
print("v1 * 2:", v1 * 2)   -- Uses __mul
print("3 * v2:", 3 * v2)   -- Uses __mul
print("v1 * v2:", v1 * v2) -- Uses __mul (dot product)
print("v1 / 2:", v1 / 2)   -- Uses __div
print("-v1:", -v1)         -- Uses __unm

-- Test comparison
print("v1 == v2:", v1 == v2) -- Uses __eq
print("v1 ~= v2:", v1 ~= v2) -- Uses __eq (inverted)

-- Test length operator
print("#v1 (magnitude):", #v1) -- Uses __len

-- Test methods
print("v1 magnitude:", v1:magnitude())
print("v1 normalized:", v1:normalize())

-- Demonstrate __index
print("\nDemonstrating __index:")
local mt = {
    __index = function(table, key)
        print("Looking for: " .. key)
        return "Not found, but here's a default value"
    end
}

local t = {}
setmetatable(t, mt)
print(t.missing) -- Will trigger __index metamethod

-- Demonstrate __newindex
print("\nDemonstrating __newindex:")
local mt2 = {
    __newindex = function(table, key, value)
        print("Setting " .. key .. " to " .. tostring(value))
        rawset(table, "prefix_" .. key, value)
    end
}

local t2 = {}
setmetatable(t2, mt2)
t2.name = "John"                         -- Will trigger __newindex
print("t2.name:", t2.name)               -- nil because we stored it with a prefix
print("t2.prefix_name:", t2.prefix_name) -- Will show "John"
