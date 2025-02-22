-- conditions.lua

-- Basic if statement
local age = 18
if age >= 18 then
    print("You are an adult") -- Will print: You are an adult
end

-- if-else statement
local temperature = 25
if temperature > 30 then
    print("It's hot!")
else
    print("It's not too hot") -- Will print: It's not too hot
end

-- if-elseif-else chain
local grade = 85
if grade >= 90 then
    print("A grade")
elseif grade >= 80 then
    print("B grade") -- Will print: B grade
elseif grade >= 70 then
    print("C grade")
else
    print("Failed")
end

-- Logical operators in conditions
local username = "admin"
local password = "secret123"

if username == "admin" and password == "secret123" then
    print("Login successful") -- Will print: Login successful
end

-- Nested if statements
local num = 15
if num > 0 then
    if num % 2 == 0 then
        print("Positive even number")
    else
        print("Positive odd number") -- Will print: Positive odd number
    end
end

-- Using not operator
local is_logged_in = false
if not is_logged_in then
    print("Please log in first") -- Will print: Please log in first
end

-- Using or operator with default values
local user_preference = nil
local theme = user_preference or "dark"
print("Theme:", theme) -- Will print: Theme: dark
