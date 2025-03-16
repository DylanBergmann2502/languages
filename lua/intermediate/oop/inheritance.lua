-- inheritance.lua
-- Demonstrating inheritance hierarchies in Lua

-- Our class creation function with support for inheritance
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

-- Animal base class
local Animal = create_class()

function Animal:init(name)
    self.name = name or "unnamed"
    self.energy = 100
end

function Animal:eat(food)
    print(self.name .. " is eating " .. food)
    self.energy = self.energy + 25
    if self.energy > 100 then
        self.energy = 100
    end
end

function Animal:sleep(hours)
    print(self.name .. " is sleeping for " .. hours .. " hours")
    self.energy = self.energy + 10 * hours
    if self.energy > 100 then
        self.energy = 100
    end
end

function Animal:move()
    if self.energy >= 10 then
        print(self.name .. " is moving")
        self.energy = self.energy - 10
    else
        print(self.name .. " is too tired to move")
    end
end

function Animal:status()
    return self.name .. " has " .. self.energy .. "% energy"
end

-- Mammal inherits from Animal
local Mammal = create_class(Animal)

function Mammal:init(name, fur_color)
    Animal.init(self, name)     -- Call base class initializer
    self.fur_color = fur_color or "brown"
    self.body_temp = 37         -- Celsius
end

function Mammal:nurse()
    if self.energy >= 15 then
        print(self.name .. " is nursing their young")
        self.energy = self.energy - 15
    else
        print(self.name .. " is too tired to nurse")
    end
end

function Mammal:status()
    -- Override and extend the base method
    return Animal.status(self) .. " and " .. self.fur_color .. " fur"
end

-- Dog inherits from Mammal
local Dog = create_class(Mammal)

function Dog:init(name, fur_color, breed)
    Mammal.init(self, name, fur_color)     -- Call parent initializer
    self.breed = breed or "mixed"
    self.loyalty = 100
end

function Dog:bark()
    print(self.name .. " says: Woof!")
    self.energy = self.energy - 5
end

function Dog:fetch(item)
    if self.energy >= 20 then
        print(self.name .. " fetches the " .. item)
        self.energy = self.energy - 20
        self.loyalty = self.loyalty + 10
    else
        print(self.name .. " is too tired to fetch")
    end
end

function Dog:status()
    -- Override and extend parent methods
    return Mammal.status(self) .. ", " .. self.breed .. " breed, and " ..
        self.loyalty .. "% loyalty"
end

-- Bird inherits from Animal
local Bird = create_class(Animal)

function Bird:init(name, wing_span)
    Animal.init(self, name)
    self.wing_span = wing_span or 30     -- cm
    self.altitude = 0                    -- meters
end

function Bird:fly(meters)
    if self.energy >= meters / 10 then
        local energy_cost = meters / 10
        print(self.name .. " is flying " .. meters .. " meters")
        self.energy = self.energy - energy_cost
        self.altitude = 10     -- Simple simulation
    else
        print(self.name .. " is too tired to fly that far")
    end
end

function Bird:status()
    local altitude_desc = ""
    if self.altitude > 0 then
        altitude_desc = " flying at " .. self.altitude .. " meters"
    else
        altitude_desc = " on the ground"
    end
    return Animal.status(self) .. ", wingspan of " .. self.wing_span .. "cm" .. altitude_desc
end

-- Utility functions for testing inheritance
local function is_instance_of(instance, class)
    local mt = getmetatable(instance)

    while mt do
        if mt == class then
            return true
        end
        -- Move up the inheritance chain
        local parent_mt = getmetatable(mt)
        if parent_mt then
            mt = parent_mt.__index
        else
            return false
        end
    end

    return false
end

-- Create instances and test
print("\n--- Testing Base Animal Class ---")
local generic_animal = Animal:new("Generic Animal")
print(generic_animal:status())
generic_animal:eat("food")
generic_animal:move()
print(generic_animal:status())

print("\n--- Testing Mammal Inheritance ---")
local generic_mammal = Mammal:new("Generic Mammal", "black")
print(generic_mammal:status())
generic_mammal:eat("berries")     -- Inherited method
generic_mammal:nurse()            -- New method
print(generic_mammal:status())

print("\n--- Testing Dog Inheritance ---")
local rex = Dog:new("Rex", "golden", "Retriever")
print(rex:status())
rex:eat("dog food")     -- From Animal
rex:nurse()             -- From Mammal
rex:bark()              -- Dog-specific
rex:fetch("ball")       -- Dog-specific
print(rex:status())

print("\n--- Testing Bird Inheritance ---")
local tweety = Bird:new("Tweety", 20)
print(tweety:status())
tweety:eat("seeds")     -- From Animal
tweety:fly(100)         -- Bird-specific
print(tweety:status())

print("\n--- Testing Instance Relationships ---")
print("Is rex an Animal?", is_instance_of(rex, Animal))           -- true
print("Is rex a Mammal?", is_instance_of(rex, Mammal))            -- true
print("Is rex a Dog?", is_instance_of(rex, Dog))                  -- true
print("Is rex a Bird?", is_instance_of(rex, Bird))                -- false

print("Is tweety an Animal?", is_instance_of(tweety, Animal))     -- true
print("Is tweety a Bird?", is_instance_of(tweety, Bird))          -- true
print("Is tweety a Mammal?", is_instance_of(tweety, Mammal))      -- false

print("\n--- Testing Method Overriding ---")
print("Animal status: " .. generic_animal:status())
print("Mammal status: " .. generic_mammal:status())
print("Dog status: " .. rex:status())
print("Bird status: " .. tweety:status())
