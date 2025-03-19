-- os_library.lua
-- Exploring Lua's os library

-- Print a separator line for better readability
local function separator()
    print("\n" .. string.rep("-", 50) .. "\n")
end

-- Date and time functions
print("Date and Time Functions:")

-- Get the current time
local current_time = os.time()
print("Current time (seconds since epoch):", current_time)

-- Convert to formatted date string
print("Formatted date:", os.date("%c", current_time))

print("\nDate format specifiers:")
print("Year: %Y =", os.date("%Y", current_time))
print("Month: %m =", os.date("%m", current_time))
print("Day: %d =", os.date("%d", current_time))
print("Hour: %H =", os.date("%H", current_time))
print("Minute: %M =", os.date("%M", current_time))
print("Second: %S =", os.date("%S", current_time))
print("Day of week: %A =", os.date("%A", current_time))
print("Month name: %B =", os.date("%B", current_time))
print("ISO date: %Y-%m-%d =", os.date("%Y-%m-%d", current_time))
print("12-hour time: %I:%M %p =", os.date("%I:%M %p", current_time))

-- Using date table
print("\nDate table:")
local date_table = os.date("*t", current_time)
for k, v in pairs(date_table) do
    print("  " .. k .. ":", v)
end

-- Converting date table back to timestamp
local new_time = os.time(date_table)
print("\nTime from date table:", new_time)

-- Calculating time differences
print("\nTime difference calculations:")
local tomorrow = os.time({
    year = date_table.year,
    month = date_table.month,
    day = date_table.day + 1,
    hour = 0,
    min = 0,
    sec = 0
})
print("Seconds until midnight:", tomorrow - current_time)

-- Measure execution time
local function measure_time(func)
    local start = os.clock()
    func()
    local elapsed = os.clock() - start
    return elapsed
end

local function test_function()
    local sum = 0
    for i = 1, 10000000 do
        sum = sum + i
    end
    return sum
end

print("\nMeasuring execution time:")
print("Time to execute test function:", measure_time(test_function), "seconds")

separator()

-- System environment functions
print("System Environment Functions:")

-- Get environment variables
print("\nEnvironment variables:")
print("PATH:", os.getenv("PATH") or "not set")
print("TEMP:", os.getenv("TEMP") or "not set")
print("HOME/USERPROFILE:", os.getenv("HOME") or os.getenv("USERPROFILE") or "not set")

-- Note about setting environment variables
print("\nNote: Standard Lua doesn't provide a function to set environment variables")
print("In some Lua distributions, you might use 'os.setenv(name, value)'")

separator()

-- Process and execution functions
print("Process and Execution Functions:")

-- Note about process ID (not available in standard Lua)
print("\nNote: Standard Lua doesn't provide a way to get the current process ID")
print("In some Lua distributions, you might use 'os.getpid()'")

-- Exit codes (just for demonstration, won't actually exit)
print("\nExit codes (not actually exiting):")
print("Normal exit would be: os.exit(0)")
print("Error exit would be: os.exit(1)")
print("Custom exit code would be: os.exit(42)")

-- Execute system commands
print("\nExecuting system commands:")

print("Directory listing:")
local success, _, code = os.execute("dir")
print("Command execution " .. (success and "succeeded" or "failed") ..
    " with exit code: " .. (code or "unknown"))

-- Using popen to capture command output
print("\nCapturing command output with popen:")
local handle = io.popen("echo Hello from command line")
if handle then
    local result = handle:read("*a")
    handle:close()
    print("Command output:", result)
else
    print("popen failed")
end

-- Get system information
print("\nSystem information:")
print("Lua version:", _VERSION)
-- Try to determine OS more precisely
local osname = "unknown"
if os.getenv("OS") == "Windows_NT" then
    osname = "Windows"
elseif os.execute("uname") then
    local uname = io.popen("uname -s")
    if uname then
        osname = uname:read("*l")
        uname:close()
    end
end
print("Detected OS:", osname)

separator()

-- File system operations
print("File System Operations (via os library):")

-- Note about current working directory (not available in standard Lua)
print("\nNote: Standard Lua doesn't provide a function to get the current working directory")
print("In some Lua distributions, you might use 'os.getcwd()'")

-- Create a temporary file
print("\nCreating temporary file:")
local temp_name = os.tmpname()
print("Temporary file name:", temp_name)

-- File operations (these are just demonstrations)
print("\nFile operations (not actually executing):")
print("Remove file: os.remove('filename.txt')")
print("Rename file: os.rename('old.txt', 'new.txt')")

-- Try to create and remove a test file
local test_file = "os_lib_test.txt"
print("\nCreating test file:", test_file)
local f = io.open(test_file, "w")
if f then
    f:write("Test content from os_library.lua")
    f:close()
    print("File created successfully")

    print("Getting file information:")
    print("Note: Standard Lua doesn't provide direct file attribute access")
    print("You can check if a file exists by attempting to open it")

    print("Removing test file")
    local success, err = os.remove(test_file)
    if success then
        print("File removed successfully")
    else
        print("Failed to remove file:", err)
    end
else
    print("Failed to create test file")
end

separator()

-- Other OS functions
print("Other OS functions:")

-- Random seed with time
print("\nRandom seed demonstration:")
math.randomseed(os.time())
print("Three random numbers after setting seed with os.time():")
for i = 1, 3 do
    print("  Random #" .. i .. ":", math.random())
end
