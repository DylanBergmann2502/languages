print("=== Arithmetic Operators ===")
local a, b = 10, 3
print(string.format("Addition: %d + %d = %d", a, b, a + b))         -- 13
print(string.format("Subtraction: %d - %d = %d", a, b, a - b))      -- 7
print(string.format("Multiplication: %d * %d = %d", a, b, a * b))   -- 30
print(string.format("Division: %d / %d = %.2f", a, b, a / b))       -- 3.33
print(string.format("Floor Division: %d // %d = %d", a, b, a // b)) -- 3
print(string.format("Modulo: %d %% %d = %d", a, b, a % b))          -- 1
print(string.format("Exponentiation: %d ^ %d = %d", a, b, a ^ b))   -- 1000

print("\n=== Relational Operators ===")
print(string.format("Equal: %d == %d: %s", a, b, tostring(a == b)))            -- false
print(string.format("Not Equal: %d ~= %d: %s", a, b, tostring(a ~= b)))        -- true
print(string.format("Greater Than: %d > %d: %s", a, b, tostring(a > b)))       -- true
print(string.format("Less Than: %d < %d: %s", a, b, tostring(a < b)))          -- false
print(string.format("Greater or Equal: %d >= %d: %s", a, b, tostring(a >= b))) -- true
print(string.format("Less or Equal: %d <= %d: %s", a, b, tostring(a <= b)))    -- false

print("\n=== Logical Operators ===")
local t, f = true, false
print(string.format("AND: %s and %s = %s", tostring(t), tostring(f), tostring(t and f))) -- false
print(string.format("OR: %s or %s = %s", tostring(t), tostring(f), tostring(t or f)))    -- true
print(string.format("NOT: not %s = %s", tostring(t), tostring(not t)))                   -- false

-- Short-circuit evaluation
print("\n=== Short-circuit Evaluation ===")
local x = 10
local result = x > 5 and "greater" or "lesser"
print("Short-circuit result: " .. result) -- greater

print("\n=== String Concatenation ===")
local str1, str2 = "Hello", "World"
print("String concat: " .. str1 .. " " .. str2) -- Hello World

print("\n=== Operator Precedence ===")
local expr1 = 2 + 3 * 4                         -- multiplication before addition
local expr2 = (2 + 3) * 4                       -- parentheses override precedence
print(string.format("2 + 3 * 4 = %d", expr1))   -- 14
print(string.format("(2 + 3) * 4 = %d", expr2)) -- 20

-- Length operator
print("\n=== Length Operator ===")
local str = "Hello"
local arr = { 1, 2, 3, 4, 5 }
print(string.format("Length of string '%s': %d", str, #str)) -- 5
print(string.format("Length of array: %d", #arr))            -- 5
