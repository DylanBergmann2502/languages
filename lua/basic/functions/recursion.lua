-- recursion.lua

-- Basic recursion example: factorial calculation
local function factorial(n)
    -- Base case: factorial of 0 or 1 is 1
    if n <= 1 then
        return 1
    end

    -- Recursive case: n! = n * (n-1)!
    return n * factorial(n - 1)
end

print("Factorial of 5:", factorial(5))   -- Factorial of 5: 120
print("Factorial of 10:", factorial(10)) -- Factorial of 10: 3628800

-- Fibonacci sequence using recursion
local function fibonacci(n)
    if n <= 0 then
        return 0
    elseif n == 1 then
        return 1
    else
        return fibonacci(n - 1) + fibonacci(n - 2)
    end
end

print("\nFibonacci sequence:")
for i = 0, 10 do
    print("fibonacci(" .. i .. ") =", fibonacci(i))
end

-- Recursive function to sum elements in a table
local function sum_table(t, index)
    index = index or 1

    -- Base case: end of table
    if index > #t then
        return 0
    end

    -- Recursive case: current element plus sum of rest
    return t[index] + sum_table(t, index + 1)
end

local numbers = { 1, 2, 3, 4, 5 }
print("\nSum of table:", sum_table(numbers)) -- Sum of table: 15

-- Recursive function to reverse a string
local function reverse_string(str)
    -- Base case: empty string or single character
    if #str <= 1 then
        return str
    end

    -- Recursive case: last character + reverse of the rest
    return string.sub(str, -1) .. reverse_string(string.sub(str, 1, -2))
end

print("\nReversed 'Hello':", reverse_string("Hello")) -- Reversed 'Hello': olleH

-- Binary search using recursion
local function binary_search(t, value, left, right)
    left = left or 1
    right = right or #t

    -- Base case: not found
    if left > right then
        return nil
    end

    local mid = math.floor((left + right) / 2)

    if t[mid] == value then
        -- Found it
        return mid
    elseif t[mid] > value then
        -- Search left half
        return binary_search(t, value, left, mid - 1)
    else
        -- Search right half
        return binary_search(t, value, mid + 1, right)
    end
end

local sorted_array = { 2, 5, 8, 12, 16, 23, 38, 56, 72, 91 }
print("\nBinary search for 23:", binary_search(sorted_array, 23)) -- Binary search for 23: 6
print("Binary search for 11:", binary_search(sorted_array, 11))   -- Binary search for 11: nil

-- Tail recursion optimization example
local function factorial_tail(n, accumulator)
    accumulator = accumulator or 1

    if n <= 1 then
        return accumulator
    end

    -- This is tail recursive because the recursive call is the last operation
    return factorial_tail(n - 1, n * accumulator)
end

print("\nTail recursive factorial of 5:", factorial_tail(5)) -- Tail recursive factorial of 5: 120

-- Mutual recursion example (even/odd)
local is_even, is_odd

is_even = function(n)
    if n == 0 then
        return true
    else
        return is_odd(n - 1)
    end
end

is_odd = function(n)
    if n == 0 then
        return false
    else
        return is_even(n - 1)
    end
end

print("\nIs 10 even?", is_even(10)) -- Is 10 even? true
print("Is 15 odd?", is_odd(15))     -- Is 15 odd? true
