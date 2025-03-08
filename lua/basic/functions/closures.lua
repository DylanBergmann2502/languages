-- closures.lua

-- Basic closure example
-- A closure is a function that captures and remembers the environment where it was created
local function counter_factory()
    local count = 0 -- Local variable in the outer function's scope

    -- Return a function that can access and modify that variable
    return function()
        count = count + 1
        return count
    end
end

local counter1 = counter_factory()
local counter2 = counter_factory()

print("Counter 1:", counter1())       -- Counter 1: 1
print("Counter 1:", counter1())       -- Counter 1: 2
print("Counter 1:", counter1())       -- Counter 1: 3

print("Counter 2:", counter2())       -- Counter 2: 1
print("Counter 2:", counter2())       -- Counter 2: 2

print("Counter 1 again:", counter1()) -- Counter 1 again: 4

-- Closure with parameters
local function multiplier(factor)
    -- Returns a function that multiplies its argument by factor
    return function(x)
        return x * factor
    end
end

local double = multiplier(2)
local triple = multiplier(3)

print("\nDouble 5:", double(5)) -- Double 5: 10
print("Triple 5:", triple(5))   -- Triple 5: 15

-- Closures to create private state
local function create_account(initial_balance)
    local balance = initial_balance or 0

    -- Return a table of functions that can access the balance
    return {
        deposit = function(amount)
            if amount > 0 then
                balance = balance + amount
                return true, balance
            end
            return false, "Invalid deposit amount"
        end,

        withdraw = function(amount)
            if amount > 0 and balance >= amount then
                balance = balance - amount
                return true, balance
            end
            return false, "Insufficient funds or invalid amount"
        end,

        get_balance = function()
            return balance
        end
    }
end

local account = create_account(100)
print("\nInitial balance:", account.get_balance()) -- Initial balance: 100

local success, new_balance = account.deposit(50)
print("After deposit:", new_balance) -- After deposit: 150

success, new_balance = account.withdraw(30)
print("After withdrawal:", new_balance) -- After withdrawal: 120

local success, message = account.withdraw(200)
print("Withdrawal result:", success, message) -- Withdrawal result: false Insufficient funds or invalid amount

-- Closures for memoization
local function memoize(func)
    local cache = {}

    return function(x)
        if cache[x] then
            print("Using cached result for", x)
            return cache[x]
        end

        local result = func(x)
        cache[x] = result
        print("Calculating and caching result for", x)
        return result
    end
end

local function expensive_calculation(n)
    -- Simulate an expensive operation
    local result = 0
    for i = 1, n * 1000 do
        result = result + i
    end
    return result
end

local memo_calc = memoize(expensive_calculation)

print("\nFirst call:")
memo_calc(5) -- Calculates and caches

print("Second call:")
memo_calc(5) -- Uses cached result

print("Different input:")
memo_calc(10) -- Calculates and caches for new input
