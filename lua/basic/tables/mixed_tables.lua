-- mixed_tables.lua
-- Demonstration of Lua tables that mix array and dictionary features

-- In Lua, a single table can act as both an array and a dictionary simultaneously
local character = {
    "Sword",       -- Array part (index 1)
    "Shield",      -- Array part (index 2)
    "Potion",      -- Array part (index 3)
    name = "Hero", -- Dictionary part (string key)
    level = 10,    -- Dictionary part (string key)
    health = 100   -- Dictionary part (string key)
}

-- Accessing array elements
print("Inventory:")
for i = 1, #character do
    print("Item " .. i .. ":", character[i])
end

-- Accessing dictionary elements
print("\nCharacter stats:")
print("Name:", character.name)
print("Level:", character.level)
print("Health:", character.health)

-- Iterating over everything with pairs()
print("\nAll character data:")
for key, value in pairs(character) do
    print(key, value)
end

-- Adding to both parts of the table
character[4] = "Bow"          -- Extend the array part
character.mana = 50           -- Add to the dictionary part
character["experience"] = 750 -- Another way to add to dictionary part

print("\nAfter adding new elements:")
print("Array length:", #character)
print("New array item:", character[4])
print("Mana:", character.mana)
print("Experience:", character.experience)

-- Mixed tables as function arguments
local function show_stats(stats)
    print("\nCharacter status:")
    for i = 1, #stats do
        print("Equipment " .. i .. ":", stats[i])
    end
    print("Name:", stats.name)
    print("Level:", stats.level)
    print("HP:", stats.health)
    if stats.mana then
        print("MP:", stats.mana)
    end
end

show_stats(character)

-- Table constructors can mix numeric and key-value pairs
local monster = {
    "Claws", -- [1] = "Claws"
    "Fangs", -- [2] = "Fangs"
    name = "Dragon",
    level = 20,
    [3] = "Scales",       -- Explicit numeric index
    ["element"] = "Fire", -- Explicit string key
    [1 + 2] = "Tail"      -- Expressions in keys
}

print("\nMonster details:")
for key, value in pairs(monster) do
    print(key, value)
end

-- Table operations on the array part
print("\nTable operations on array part:")
table.insert(character, "Magic Staff")
print("After insert:", character[5])

table.remove(character, 2) -- Remove "Shield"
print("Array after removal:")
for i = 1, #character do
    print(i, character[i])
end

-- Nested mixed tables
local game = {
    title = "Epic Adventure",
    version = 1.5,
    characters = {
        {
            "Sword",
            "Armor",
            name = "Warrior",
            strength = 15
        },
        {
            "Staff",
            "Robe",
            name = "Wizard",
            intelligence = 18
        }
    },
    settings = {
        difficulty = "Normal",
        sound = true,
        display = {
            resolution = "1920x1080",
            fullscreen = true
        }
    }
}

print("\nGame information:")
print("Title:", game.title)
print("First character name:", game.characters[1].name)
print("First character weapon:", game.characters[1][1])
print("Display resolution:", game.settings.display.resolution)

-- Using a mixed table as a state container
local game_state = {
    1,
    2,
    3,       -- These could be level IDs
    current_player = "Player1",
    score = 0,
    is_game_over = false,

    -- We can even add functions
    add_score = function(self, points)
        self.score = self.score + points
        print("Score updated to " .. self.score)
    end
}

print("\nGame state:")
game_state:add_score(10)
game_state:add_score(5)
print("Final score:", game_state.score)
