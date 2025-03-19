-- math_library.lua
-- Exploring Lua's math library

-- Print a separator line for better readability
local function separator()
    print("\n" .. string.rep("-", 50) .. "\n")
end

-- Basic constants
print("Math constants:")
print("Pi:", math.pi)
print("Huge (infinity):", math.huge)
print("Maximum integer value that can be stored:", math.maxinteger)
print("Minimum integer value that can be stored:", math.mininteger)

separator()

-- Basic arithmetic functions
print("Basic arithmetic functions:")
print("Absolute value of -10:", math.abs(-10))
print("Sign of -5:", math.sign(-5)) -- Returns -1 for negative, 0 for zero, 1 for positive

-- Minimum and maximum
print("Minimum of 5, 2, 8:", math.min(5, 2, 8))
print("Maximum of 5, 2, 8:", math.max(5, 2, 8))

separator()

-- Rounding functions
print("Rounding functions:")
local x = 3.3
local y = 3.7
local z = -3.7

print("Original values:", x, y, z)
print("Floor (round down):", math.floor(x), math.floor(y), math.floor(z))
print("Ceiling (round up):", math.ceil(x), math.ceil(y), math.ceil(z))

-- Rounding to nearest integer
print("Round to nearest integer:")
print("math.modf (returns integer part and fractional part):")
local int_part, frac_part = math.modf(3.75)
print("  3.75 ->", int_part, frac_part)

print("math.floor(x + 0.5) (common rounding method):")
print("  3.3 rounded:", math.floor(x + 0.5))
print("  3.7 rounded:", math.floor(y + 0.5))

-- Truncate function (in Lua 5.3 and later)
if math.tointeger then
    print("Truncate (convert to integer by removing decimal part):")
    print("  math.tointeger(3.7):", math.tointeger(3.7))
    print("  math.tointeger(3.0):", math.tointeger(3.0))
    print("  math.tointeger(3.1e20) (too large):", math.tointeger(3.1e20))
end

separator()

-- Power and logarithmic functions
print("Power and logarithmic functions:")
print("2^3 (using operator):", 2 ^ 3)
print("2^3 (using math.pow):", math.pow(2, 3))

print("Square root of 16:", math.sqrt(16))
print("Cube root of 27:", math.pow(27, 1 / 3))

print("Natural logarithm (base e) of 10:", math.log(10))
print("Base-10 logarithm of 100:", math.log(100, 10))
print("Base-2 logarithm of 8:", math.log(8, 2))

separator()

-- Trigonometric functions (in radians)
print("Trigonometric functions:")
print("sin(π/2):", math.sin(math.pi / 2)) -- Should be 1
print("cos(π):", math.cos(math.pi)) -- Should be -1
print("tan(π/4):", math.tan(math.pi / 4)) -- Should be 1

print("\nInverse trigonometric functions:")
print("asin(1):", math.asin(1)) -- Should be π/2
print("acos(0):", math.acos(0)) -- Should be π/2
print("atan(1):", math.atan(1)) -- Should be π/4

print("\natan2 (two-argument arctangent):")
print("atan2(1, 1):", math.atan2(1, 1))     -- Should be π/4
print("atan2(-1, -1):", math.atan2(-1, -1)) -- Should be -3π/4

separator()

-- Hyperbolic functions
print("Hyperbolic functions:")
print("sinh(1):", math.sinh(1))
print("cosh(1):", math.cosh(1))
print("tanh(1):", math.tanh(1))

separator()

-- Angle conversion
print("Angle conversion:")
local degrees = 180
local radians = math.rad(degrees)
print(degrees .. "° in radians:", radians)
print(radians .. " radians in degrees:", math.deg(radians))

separator()

-- Random number generation
print("Random number generation:")
-- Set a seed for reproducible results
math.randomseed(os.time())
print("Random seed set to:", os.time())

-- Generate random integers
print("Random integer between 1 and 6 (die roll):")
for i = 1, 5 do
    print("  Roll #" .. i .. ":", math.random(1, 6))
end

-- Generate random float in [0,1)
print("\nRandom float between 0 and 1:")
for i = 1, 3 do
    print("  Random #" .. i .. ":", math.random())
end

-- Generate random float in range
local function random_float(min, max)
    return min + math.random() * (max - min)
end

print("\nRandom float between 10 and 20:")
for i = 1, 3 do
    print("  Random #" .. i .. ":", random_float(10, 20))
end

separator()

-- Practical examples
print("Practical examples:")

-- Distance between two points
local function distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx ^ 2 + dy ^ 2)
end

print("Distance between (0,0) and (3,4):", distance(0, 0, 3, 4))

-- Generate a point on a circle
local function point_on_circle(radius, angle_degrees)
    local angle_rad = math.rad(angle_degrees)
    local x = radius * math.cos(angle_rad)
    local y = radius * math.sin(angle_rad)
    return x, y
end

print("\nPoints on a circle with radius 5:")
for angle = 0, 360, 90 do
    local x, y = point_on_circle(5, angle)
    print("  At " .. angle .. "°: (" .. x .. ", " .. y .. ")")
end

-- Linear interpolation
local function lerp(a, b, t)
    return a + (b - a) * t
end

print("\nLinear interpolation between 0 and 10:")
for t = 0, 1, 0.25 do
    print("  t = " .. t .. ": " .. lerp(0, 10, t))
end
