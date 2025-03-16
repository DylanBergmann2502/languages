-- polymorphism.lua
-- Demonstrating polymorphic behavior in Lua

-- Our class creation function
local function create_class(base_class)
    local new_class = {}
    new_class.__index = new_class

    -- Set up inheritance
    if base_class then
        setmetatable(new_class, {
            __index = base_class     -- This allows method lookup in the base class
        })
    end

    -- Constructor that creates new instances
    function new_class:new(...)
        local instance = setmetatable({}, self)
        if instance.init then
            instance:init(...)
        end
        return instance
    end

    return new_class
end

-- Shape - Abstract base class
local Shape = create_class()

function Shape:init(x, y)
    self.x = x or 0
    self.y = y or 0
end

function Shape:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
    return self
end

function Shape:position()
    return string.format("(%d, %d)", self.x, self.y)
end

function Shape:area()
    error("Shape:area() must be implemented by subclasses")
end

function Shape:perimeter()
    error("Shape:perimeter() must be implemented by subclasses")
end

function Shape:draw()
    print("Drawing a shape at " .. self:position())
end

function Shape:to_string()
    return "Shape at " .. self:position()
end

-- Rectangle class
local Rectangle = create_class(Shape)

function Rectangle:init(x, y, width, height)
    Shape.init(self, x, y)
    self.width = width or 0
    self.height = height or 0
end

function Rectangle:area()
    return self.width * self.height
end

function Rectangle:perimeter()
    return 2 * (self.width + self.height)
end

function Rectangle:draw()
    print(string.format("Drawing a rectangle at %s with dimensions %dx%d",
        self:position(), self.width, self.height))
end

function Rectangle:to_string()
    return string.format("Rectangle at %s with dimensions %dx%d",
        self:position(), self.width, self.height)
end

-- Circle class
local Circle = create_class(Shape)

function Circle:init(x, y, radius)
    Shape.init(self, x, y)
    self.radius = radius or 0
end

function Circle:area()
    return math.pi * self.radius * self.radius
end

function Circle:perimeter()
    return 2 * math.pi * self.radius
end

function Circle:draw()
    print(string.format("Drawing a circle at %s with radius %d",
        self:position(), self.radius))
end

function Circle:to_string()
    return string.format("Circle at %s with radius %d",
        self:position(), self.radius)
end

-- Triangle class
local Triangle = create_class(Shape)

function Triangle:init(x, y, side1, side2, side3)
    Shape.init(self, x, y)
    self.side1 = side1 or 0
    self.side2 = side2 or 0
    self.side3 = side3 or 0
end

function Triangle:area()
    -- Using Heron's formula
    local s = self:perimeter() / 2
    return math.sqrt(s * (s - self.side1) * (s - self.side2) * (s - self.side3))
end

function Triangle:perimeter()
    return self.side1 + self.side2 + self.side3
end

function Triangle:draw()
    print(string.format("Drawing a triangle at %s with sides %d, %d, %d",
        self:position(), self.side1, self.side2, self.side3))
end

function Triangle:to_string()
    return string.format("Triangle at %s with sides %d, %d, %d",
        self:position(), self.side1, self.side2, self.side3)
end

-- Enhancing our classes with __tostring metamethod
local function add_tostring_metamethod(class)
    local mt = getmetatable(class) or {}
    mt.__call = mt.__call or class.new     -- For convenient instantiation

    -- Add __tostring metamethod to instances
    local orig_new = class.new
    class.new = function(...)
        local instance = orig_new(...)
        -- Add __tostring to the instance
        local instance_mt = getmetatable(instance)
        instance_mt.__tostring = function(self)
            return self:to_string()
        end
        return instance
    end

    setmetatable(class, mt)
    return class
end

-- Apply metamethods to all classes
add_tostring_metamethod(Shape)
add_tostring_metamethod(Rectangle)
add_tostring_metamethod(Circle)
add_tostring_metamethod(Triangle)

-- Demonstrate polymorphism

-- 1. Function that works with any shape
local function calculate_and_print_area(shape)
    print(shape:to_string() .. " has area: " .. shape:area())
end

local function calculate_and_print_perimeter(shape)
    print(shape:to_string() .. " has perimeter: " .. shape:perimeter())
end

local function draw_shape(shape)
    shape:draw()     -- Each shape knows how to draw itself
end

-- 2. Storing different types in the same collection
local function create_random_shape()
    local shape_type = math.random(1, 3)
    local x, y = math.random(0, 100), math.random(0, 100)

    if shape_type == 1 then
        local width, height = math.random(1, 50), math.random(1, 50)
        return Rectangle:new(x, y, width, height)
    elseif shape_type == 2 then
        local radius = math.random(1, 30)
        return Circle:new(x, y, radius)
    else
        local side1 = math.random(5, 20)
        local side2 = math.random(5, 20)
        local side3 = math.random(5, 20)
        -- Make sure it's a valid triangle (sum of any two sides > third side)
        while side1 + side2 <= side3 or side1 + side3 <= side2 or side2 + side3 <= side1 do
            side1 = math.random(5, 20)
            side2 = math.random(5, 20)
            side3 = math.random(5, 20)
        end
        return Triangle:new(x, y, side1, side2, side3)
    end
end

-- Seed the random number generator
math.randomseed(os.time())

-- Create some shapes
local rect = Rectangle:new(10, 20, 30, 40)
local circle = Circle:new(50, 60, 25)
local triangle = Triangle:new(70, 80, 10, 15, 20)

print("\n--- Individual Shapes ---")
print(rect)         -- Uses __tostring metamethod
print(circle)       -- Uses __tostring metamethod
print(triangle)     -- Uses __tostring metamethod

print("\n--- Polymorphic Function Calls ---")
calculate_and_print_area(rect)
calculate_and_print_area(circle)
calculate_and_print_area(triangle)

print("")
calculate_and_print_perimeter(rect)
calculate_and_print_perimeter(circle)
calculate_and_print_perimeter(triangle)

print("\n--- Polymorphic Method Calls ---")
draw_shape(rect)
draw_shape(circle)
draw_shape(triangle)

print("\n--- Collection of Different Shapes ---")
local shapes = {}
for i = 1, 5 do
    shapes[i] = create_random_shape()
end

print("\nDrawing and calculating properties for random shapes:")
for i, shape in ipairs(shapes) do
    print("\nShape " .. i .. ":")
    draw_shape(shape)
    calculate_and_print_area(shape)
    calculate_and_print_perimeter(shape)
end
