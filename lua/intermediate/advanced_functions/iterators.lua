-- iterators.lua

-- Iterators allow us to traverse data structures in a controlled way
-- Lua uses the "for-in" loop with iterators to traverse collections

print("=== BASIC ITERATOR CONCEPTS ===")

-- 1. Using built-in iterators
print("\n--- Built-in iterators ---")

-- ipairs: Iterates over array part of a table with numeric indices
local fruits = { "apple", "banana", "cherry" }
print("Iterating with ipairs:")
for i, fruit in ipairs(fruits) do
    print(i, fruit)
end

-- pairs: Iterates over all table keys (both numeric and string)
local person = {
    name = "Alice",
    age = 30,
    [1] = "first item"
}
print("\nIterating with pairs:")
for key, value in pairs(person) do
    print(key, value)
end

-- 2. Creating a basic iterator using closures
print("\n--- Custom iterator using closures ---")

local function count_to(max)
    local current = 0
    -- This is the iterator function that gets called in each loop
    return function()
        current = current + 1
        if current <= max then
            return current
        end
    end
end

print("Counting to 5:")
for num in count_to(5) do
    print(num)
end

-- 3. Creating a stateful iterator (the standard Lua way)
print("\n--- Stateful iterator with factory, iterator, state ---")

-- This follows the pattern expected by Lua's for-in loop:
-- for var_1, ..., var_n in explist do block end

local function range(start, stop, step)
    -- Iterator factory returns: iterator function, state, initial value
    step = step or 1
    local current = start - step

    -- The iterator function gets called repeatedly with state and control variable
    local function iter(state, _)
        current = current + step
        if current <= stop then
            return current
        end
    end

    return iter, {}, nil -- Iterator, state, initial value
end

print("Range from 1 to 10, step 2:")
for num in range(1, 10, 2) do
    print(num)
end

-- 4. Iterator over a custom data structure
print("\n--- Custom data structure iterator ---")

-- Let's create a simple linked list
local function create_linked_list(...)
    local args = { ... }
    local head = nil

    -- Build the list from the end
    for i = #args, 1, -1 do
        head = { value = args[i], next = head }
    end

    return head
end

local function list_iter(list)
    local current = list
    return function()
        if current then
            local value = current.value
            current = current.next
            return value
        end
    end
end

local my_list = create_linked_list("one", "two", "three", "four")

print("Iterating through linked list:")
for item in list_iter(my_list) do
    print(item)
end

-- 5. Iterator that generates values without a collection
print("\n--- Generator iterator ---")

local function fibonacci(max_value)
    local a, b = 0, 1
    return function()
        if a > max_value then return nil end
        local value = a
        a, b = b, a + b
        return value
    end
end

print("Fibonacci sequence up to 100:")
for num in fibonacci(100) do
    print(num)
end

-- 6. Coroutine-based iterators
print("\n--- Coroutine-based iterator ---")

local function permutations(t)
    -- This uses coroutine to yield all permutations of a table
    local n = #t
    local function perm(t, n)
        if n == 0 then
            coroutine.yield(table.concat(t))
        else
            for i = 1, n do
                -- Swap elements
                t[i], t[n] = t[n], t[i]
                perm(t, n - 1)
                -- Restore original order
                t[i], t[n] = t[n], t[i]
            end
        end
    end

    return coroutine.wrap(function() perm(t, n) end)
end

print("Permutations of 'abc':")
for p in permutations({ "a", "b", "c" }) do
    print(p)
end

-- 7. Using iterators with multiple return values
print("\n--- Iterator with multiple values ---")

local function entries(t)
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end

    -- Sort keys for consistent iteration
    table.sort(keys)

    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

local data = {
    name = "Bob",
    city = "New York",
    profession = "Developer"
}

print("Sorted entries:")
for k, v in entries(data) do
    print(k, v)
end

-- 8. Chaining iterators
print("\n--- Chaining iterators ---")

local numbers = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }

-- Iterator to get even numbers
local function even_numbers(arr)
    local index = 0
    local count = #arr

    return function()
        while index < count do
            index = index + 1
            if arr[index] % 2 == 0 then
                return arr[index]
            end
        end
    end
end

-- Iterator to square numbers
local function squares(iterator)
    return function()
        local value = iterator()
        if value then
            return value * value
        end
    end
end

print("Even squares from 1-10:")
local even_iter = even_numbers(numbers)
local square_iter = squares(even_iter)

local value = square_iter()
while value do
    print(value)
    value = square_iter()
end
