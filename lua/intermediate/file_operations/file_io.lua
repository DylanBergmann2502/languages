-- file_io.lua
-- Basic file operations in Lua

-- Opening a file for writing
local function write_to_file()
    print("=== Writing to a file ===")

    -- Open file in write mode ('w')
    local file = io.open("test_file.txt", "w")

    -- Check if file was opened successfully
    if not file then
        print("Error: Could not open file for writing")
        return
    end

    -- Write content to the file
    file:write("Hello, Lua file I/O!\n")
    file:write("This is line 2\n")
    file:write("This is line 3\n")

    -- Writing multiple values at once
    file:write("Numbers: ", 42, " ", 3.14, "\n")

    -- Close the file (important!)
    file:close()

    print("Successfully wrote to test_file.txt")
end

-- Reading an entire file at once
local function read_entire_file()
    print("\n=== Reading entire file at once ===")

    -- Open file in read mode ('r' - default mode)
    local file = io.open("test_file.txt", "r")

    if not file then
        print("Error: Could not open file for reading")
        return
    end

    -- Read the entire file content
    local content = file:read("*all")
    file:close()

    print("File content:")
    print(content)
end

-- Reading a file line by line
local function read_file_by_lines()
    print("\n=== Reading file line by line ===")

    local file = io.open("test_file.txt", "r")

    if not file then
        print("Error: Could not open file for reading")
        return
    end

    print("File content (line by line):")

    -- Iterate through each line
    for line in file:lines() do
        print(line)
    end

    file:close()
end

-- Appending to a file
local function append_to_file()
    print("\n=== Appending to a file ===")

    -- Open file in append mode ('a')
    local file = io.open("test_file.txt", "a")

    if not file then
        print("Error: Could not open file for appending")
        return
    end

    file:write("This line was appended!\n")
    file:write("Another appended line.\n")
    file:close()

    print("Successfully appended to test_file.txt")
end

-- Reading specific portions of a file
local function read_file_portions()
    print("\n=== Reading specific portions of a file ===")

    local file = io.open("test_file.txt", "r")

    if not file then
        print("Error: Could not open file for reading")
        return
    end

    -- Read first line
    local first_line = file:read("*line")
    print("First line:", first_line)

    -- Read next 5 characters
    local next_chars = file:read(5)
    print("Next 5 characters:", next_chars)

    -- Read the next line
    local next_line = file:read("*line")
    print("Rest of the line:", next_line)

    file:close()
end

-- Using file position
local function file_position()
    print("\n=== Working with file position ===")

    local file = io.open("test_file.txt", "r")

    if not file then
        print("Error: Could not open file for reading")
        return
    end

    -- Get current position
    local pos = file:seek()
    print("Initial position:", pos)

    -- Read first line
    local line = file:read("*line")
    print("First line:", line)

    -- Get new position
    pos = file:seek()
    print("Position after reading first line:", pos)

    -- Set position to beginning of file
    file:seek("set", 0)
    print("Reset to beginning, position:", file:seek())

    -- Read first 10 characters
    print("First 10 chars:", file:read(10))

    -- Move 5 characters forward from current position
    file:seek("cur", 5)
    print("After skipping 5 chars, next 10 chars:", file:read(10))

    file:close()
end

-- Using io.input and io.output (default file handles)
local function default_io_handles()
    print("\n=== Using default I/O handles ===")

    -- Set default input file
    io.input("test_file.txt")

    -- Now we can read without opening the file explicitly
    print("First line using io.input:", io.read("*line"))
    print("Second line using io.input:", io.read("*line"))

    -- Set default output file
    io.output("output_file.txt")

    -- Write to default output
    io.write("This is written to output_file.txt\n")
    io.write("Another line in output_file.txt\n")

    -- Reset default input/output to stdin/stdout
    io.input(io.stdin)
    io.output(io.stdout)

    print("Default I/O handles reset to standard input/output")
    print("Created output_file.txt")
end

-- Binary file operations
local function binary_file_operations()
    print("\n=== Binary file operations ===")

    -- Create a binary file
    local file = io.open("binary_file.bin", "wb")

    if not file then
        print("Error: Could not open binary file for writing")
        return
    end

    -- Write binary data
    file:write(string.char(65, 66, 67, 0, 255, 127))
    file:close()

    print("Wrote binary data to binary_file.bin")

    -- Read binary data
    file = io.open("binary_file.bin", "rb")

    if not file then
        print("Error: Could not open binary file for reading")
        return
    end

    local data = file:read("*all")
    file:close()

    print("Read binary data, byte values:")
    for i = 1, #data do
        io.write(string.byte(data, i), " ")
    end
    print()
end

-- Function to clean up all test files
local function cleanup_files()
    print("\n=== Cleaning up test files ===")

    -- List of files to remove
    local files_to_remove = {
        "test_file.txt",
        "output_file.txt",
        "binary_file.bin"
    }

    for _, filename in ipairs(files_to_remove) do
        -- Check if file exists before attempting to remove
        local file = io.open(filename, "r")
        if file then
            file:close()
            -- In Lua we use os.remove to delete files
            local success, err = os.remove(filename)
            if success then
                print("Removed file: " .. filename)
            else
                print("Failed to remove " .. filename .. ": " .. err)
            end
        else
            print("File not found: " .. filename)
        end
    end

    print("Cleanup completed")
end

-- Execute examples
write_to_file()
read_entire_file()
read_file_by_lines()
append_to_file()
read_entire_file() -- Read again to see appended content
read_file_portions()
file_position()
default_io_handles()
binary_file_operations()

-- Clean up at the end
cleanup_files()

print("\nFile I/O operations completed.")
