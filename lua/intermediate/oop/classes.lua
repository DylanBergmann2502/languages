-- classes.lua
-- Demonstrating OOP in Lua using metatables to create a class system

-- Define a simple class system
local function create_class(base_class)
    -- Create a new class table
    local new_class = {}

    -- If there's a base class, set up inheritance
    if base_class then
        -- Copy base class methods
        for key, value in pairs(base_class) do
            if key ~= "new" then -- Don't copy the constructor
                new_class[key] = value
            end
        end

        -- Remember the base class for inheritance
        new_class._base = base_class
    end

    -- Class constructor that creates new instances
    function new_class.new(...)
        local instance = {}

        -- Set the metatable for the instance
        setmetatable(instance, {
            __index = new_class, -- Look up methods in the class
        })

        -- Call initializer if it exists
        if instance.init then
            instance:init(...)
        end

        return instance
    end

    return new_class
end

-- Example: Shape class (base class)
local Shape = create_class()

function Shape:init(x, y)
    self.x = x or 0
    self.y = y or 0
end

function Shape:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

function Shape:position()
    return string.format("Position: (%d, %d)", self.x, self.y)
end

function Shape:area()
    -- To be overridden by subclasses
    return 0
end

function Shape:to_string()
    return "Shape at " .. self:position()
end

-- Rectangle class (inherits from Shape)
local Rectangle = create_class(Shape)

function Rectangle:init(x, y, width, height)
    -- Call base class initializer
    Shape.init(self, x, y)

    self.width = width or 0
    self.height = height or 0
end

function Rectangle:area()
    -- Override base class method
    return self.width * self.height
end

function Rectangle:to_string()
    return string.format("Rectangle at %s with dimensions %dx%d",
        self:position(), self.width, self.height)
end

-- Circle class (inherits from Shape)
local Circle = create_class(Shape)

function Circle:init(x, y, radius)
    -- Call base class initializer
    Shape.init(self, x, y)

    self.radius = radius or 0
end

function Circle:area()
    -- Override base class method
    return math.pi * self.radius * self.radius
end

function Circle:to_string()
    return string.format("Circle at %s with radius %d",
        self:position(), self.radius)
end

-- Advanced: add toString metamethod to make printing objects nicer
local meta_with_tostring = {
    __tostring = function(self)
        if self.to_string then
            return self:to_string()
        else
            return tostring(self)
        end
    end
}

-- Apply this metamethod to our classes
setmetatable(Shape, meta_with_tostring)
setmetatable(Rectangle, meta_with_tostring)
setmetatable(Circle, meta_with_tostring)

-- Create instances and test
print("Creating a shape at position (10, 20):")
local shape = Shape.new(10, 20)
print(shape:position())
print("Area:", shape:area())
print(shape:to_string())
print("")

print("Creating a rectangle at (5, 5) with width=10, height=20:")
local rect = Rectangle.new(5, 5, 10, 20)
print(rect:position())
print("Area:", rect:area())
print(rect:to_string())

-- Move the rectangle
rect:move(3, 7)
print("After moving rectangle by (3, 7):")
print(rect:position())
print("")

print("Creating a circle at (15, 25) with radius=8:")
local circle = Circle.new(15, 25, 8)
print(circle:position())
print("Area:", circle:area())
print(circle:to_string())
print("")

-- Demonstrate how to check instance type (poor man's instanceof)
print("Checking types:")
print("Is rect a Rectangle?", rect.x ~= nil and rect.width ~= nil)
print("Is circle a Circle?", circle.radius ~= nil)
print("Is circle a Shape?", circle.x ~= nil)

-- Advanced: Type checking using the class hierarchy
local function instance_of(instance, class)
    local mt = getmetatable(instance)
    while mt do
        if mt.__index == class then
            return true
        end
        mt = getmetatable(mt.__index)
    end
    return false
end

print("")
print("Better type checking:")
print("Is rect a Rectangle?", instance_of(rect, Rectangle))
print("Is rect a Shape?", instance_of(rect, Shape))
print("Is rect a Circle?", instance_of(rect, Circle))
