-- file_system.lua
-- File system operations in Lua

-- Create a utility function to check if a file or directory exists
local function exists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

-- Function to check if a path is a directory
local function is_directory(path)
    -- In Windows, we need to check differently than in Unix
    local cmd
    if package.config:sub(1, 1) == '\\' then    -- Windows
        cmd = 'if exist "' .. path .. '\\*" echo DIR'
    else                                        -- Unix
        cmd = 'test -d "' .. path .. '" && echo DIR'
    end

    local f = io.popen(cmd)
    local result = f:read("*a")
    f:close()

    return result:match("DIR") ~= nil
end

-- Get current working directory
local function get_current_directory()
    print("=== Current Working Directory ===")

    -- Use Lua's io.popen to execute the appropriate command
    local cmd = package.config:sub(1, 1) == '\\' and 'cd' or 'pwd'
    local f = io.popen(cmd)
    local current_dir = f:read("*a"):gsub("\n$", "")
    f:close()

    print("Current directory: " .. current_dir)
    return current_dir
end

-- List files in a directory
local function list_directory(path)
    print("\n=== Listing Directory Contents ===")

    path = path or "."     -- Default to current directory
    print("Listing contents of: " .. path)

    local cmd
    if package.config:sub(1, 1) == '\\' then    -- Windows
        cmd = 'dir /b "' .. path .. '"'
    else                                        -- Unix
        cmd = 'ls -1 "' .. path .. '"'
    end

    local f = io.popen(cmd)
    local result = f:read("*all")
    f:close()

    if result == "" then
        print("Directory is empty or doesn't exist")
        return {}
    end

    -- Parse result to get file list
    local files = {}
    for name in result:gmatch("([^\n]+)") do
        table.insert(files, name)
        print(name .. (is_directory(path .. "/" .. name) and " (directory)" or " (file)"))
    end

    return files
end

-- Create a directory
local function create_directory(path)
    print("\n=== Creating Directory ===")

    -- Don't overwrite existing directories
    if exists(path) then
        print("Cannot create directory: " .. path .. " (already exists)")
        return false
    end

    -- Use os.execute to run mkdir command
    local cmd
    if package.config:sub(1, 1) == '\\' then    -- Windows
        cmd = 'mkdir "' .. path .. '"'
    else                                        -- Unix
        cmd = 'mkdir -p "' .. path .. '"'
    end

    local success = os.execute(cmd)

    if success then
        print("Created directory: " .. path)
        return true
    else
        print("Failed to create directory: " .. path)
        return false
    end
end

-- Remove a directory
local function remove_directory(path)
    print("\n=== Removing Directory ===")

    if not exists(path) then
        print("Cannot remove directory: " .. path .. " (doesn't exist)")
        return false
    end

    if not is_directory(path) then
        print("Cannot remove directory: " .. path .. " (not a directory)")
        return false
    end

    -- Use os.execute to run rmdir command
    local cmd
    if package.config:sub(1, 1) == '\\' then    -- Windows
        cmd = 'rmdir "' .. path .. '"'
    else                                        -- Unix
        cmd = 'rmdir "' .. path .. '"'
    end

    local success = os.execute(cmd)

    if success then
        print("Removed directory: " .. path)
        return true
    else
        print("Failed to remove directory: " .. path .. " (may not be empty)")
        return false
    end
end

-- Get file information
local function get_file_info(path)
    print("\n=== File Information ===")

    if not exists(path) then
        print("Cannot get info: " .. path .. " (doesn't exist)")
        return nil
    end

    local info = {}

    -- Get file size
    local f = io.open(path, "rb")
    if f then
        local size = f:seek("end")
        f:close()
        info.size = size
        print("File size: " .. size .. " bytes")
    end

    -- Get file modification time
    local cmd
    if package.config:sub(1, 1) == '\\' then    -- Windows
        cmd = 'for %I in ("' .. path .. '") do @echo %~tI'
    else                                        -- Unix
        cmd = 'stat -c %y "' .. path .. '"'
    end

    local f = io.popen(cmd)
    local time = f:read("*a"):gsub("\n$", "")
    f:close()

    info.modification_time = time
    print("Last modified: " .. time)

    -- Check if it's a directory
    info.is_directory = is_directory(path)
    print("Is directory: " .. tostring(info.is_directory))

    return info
end

-- Create and manipulate temporary files
local function temp_file_operations()
    print("\n=== Temporary File Operations ===")

    -- Generate a temporary file name
    local temp_name = os.tmpname()
    print("Generated temporary file name: " .. temp_name)

    -- Create and write to the temporary file
    local f = io.open(temp_name, "w")
    if f then
        f:write("This is temporary content")
        f:close()
        print("Wrote to temporary file")
    else
        print("Failed to write to temporary file")
        return
    end

    -- Read the temporary file
    f = io.open(temp_name, "r")
    if f then
        local content = f:read("*all")
        f:close()
        print("Temporary file content: " .. content)
    end

    -- Remove the temporary file
    os.remove(temp_name)
    print("Removed temporary file")

    -- Verify removal
    if not exists(temp_name) then
        print("Verified: Temporary file was removed")
    else
        print("Warning: Temporary file still exists")
    end
end

-- Rename/move files
local function rename_file(old_path, new_path)
    print("\n=== Renaming/Moving File ===")

    if not exists(old_path) then
        print("Cannot rename: " .. old_path .. " (doesn't exist)")
        return false
    end

    if exists(new_path) then
        print("Cannot rename to: " .. new_path .. " (already exists)")
        return false
    end

    local success, err = os.rename(old_path, new_path)

    if success then
        print("Renamed " .. old_path .. " to " .. new_path)
        return true
    else
        print("Failed to rename: " .. (err or "unknown error"))
        return false
    end
end

-- Copy a file
local function copy_file(source, destination)
    print("\n=== Copying File ===")

    if not exists(source) then
        print("Cannot copy: " .. source .. " (doesn't exist)")
        return false
    end

    if exists(destination) then
        print("Warning: Overwriting existing file: " .. destination)
    end

    -- Open source file for reading in binary mode
    local source_file = io.open(source, "rb")
    if not source_file then
        print("Failed to open source file for reading")
        return false
    end

    -- Open destination file for writing in binary mode
    local dest_file = io.open(destination, "wb")
    if not dest_file then
        source_file:close()
        print("Failed to open destination file for writing")
        return false
    end

    -- Copy data in chunks
    local chunk_size = 8192     -- 8KB chunks
    while true do
        local chunk = source_file:read(chunk_size)
        if not chunk then break end
        dest_file:write(chunk)
    end

    source_file:close()
    dest_file:close()

    print("Copied " .. source .. " to " .. destination)
    return true
end

-- Get file path components
local function path_components(path)
    print("\n=== Path Components ===")

    print("Original path: " .. path)

    -- Get directory separator
    local sep = package.config:sub(1, 1)    -- Windows: '\', Unix: '/'

    -- Extract directory
    local dir = path:match("(.*" .. sep .. ")")
    dir = dir or ""
    print("Directory: " .. dir)

    -- Extract filename
    local filename = path:match(".*" .. sep .. "(.*)") or path
    print("Filename: " .. filename)

    -- Extract extension
    local name, ext = filename:match("(.*)%.(.*)$")
    if name and ext then
        print("Base name: " .. name)
        print("Extension: " .. ext)
    else
        print("Base name: " .. filename)
        print("Extension: none")
    end
end

-- Clean up function
local function cleanup()
    print("\n=== Cleaning Up ===")

    -- Files to clean up
    local test_dir = "test_directory"
    local test_file = "test_file.txt"
    local renamed_file = "renamed_file.txt"
    local copied_file = "copied_file.txt"

    -- Remove files if they exist
    for _, file in ipairs({ test_file, renamed_file, copied_file }) do
        if exists(file) then
            os.remove(file)
            print("Removed: " .. file)
        end
    end

    -- Remove directory if it exists
    if exists(test_dir) and is_directory(test_dir) then
        remove_directory(test_dir)
    end

    print("Cleanup completed")
end

-- Main function to demonstrate file system operations
local function main()
    -- Create a test file
    local test_file = "test_file.txt"
    local f = io.open(test_file, "w")
    if f then
        f:write("This is a test file for file system operations")
        f:close()
        print("Created test file: " .. test_file)
    end

    -- Run demonstrations
    get_current_directory()
    list_directory(".")
    create_directory("test_directory")
    list_directory(".")
    get_file_info(test_file)
    rename_file(test_file, "renamed_file.txt")
    copy_file("renamed_file.txt", "copied_file.txt")
    path_components("C:\\Users\\example\\Documents\\script.lua")
    path_components("/home/user/documents/script.lua")
    temp_file_operations()

    -- Clean up after tests
    cleanup()

    print("\nFile system operations completed.")
end

-- Run the main function
main()
