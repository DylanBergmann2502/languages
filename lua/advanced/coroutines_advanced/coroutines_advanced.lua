-- Advanced Lua Coroutines

-- Utilities to help visualize coroutine state
local function print_status(co)
    print("Coroutine status: " .. coroutine.status(co))
end

local function print_separator()
    print("\n" .. string.rep("-", 50) .. "\n")
end

-- Example 1: Error handling with coroutines
print("EXAMPLE 1: ERROR HANDLING IN COROUTINES")

local function error_prone_function()
    print("Starting error-prone function")
    coroutine.yield("First yield successful")

    -- This will throw an error
    error("Deliberate error in coroutine")

    -- This will never be reached
    coroutine.yield("You'll never see this")
end

local error_co = coroutine.create(error_prone_function)
print_status(error_co)

-- First resume succeeds
local success, message = coroutine.resume(error_co)
print("Success:", success, "Message:", message)
print_status(error_co)

-- Second resume will propagate the error
local success, error_message = coroutine.resume(error_co)
print("Success:", success, "Error:", error_message)
print_status(error_co)

print_separator()

-- Example 2: Coroutine-based task scheduler
print("EXAMPLE 2: SIMPLE TASK SCHEDULER")

local scheduler = {}
scheduler.tasks = {}
scheduler.time = 0

function scheduler.add_task(delay, action)
    local task = coroutine.create(function()
        local deadline = scheduler.time + delay
        while scheduler.time < deadline do
            coroutine.yield()
        end
        return action()
    end)

    table.insert(scheduler.tasks, task)
    return task
end

function scheduler.run()
    while #scheduler.tasks > 0 do
        -- Simulate time passing
        scheduler.time = scheduler.time + 1
        print("Current time:", scheduler.time)

        local remaining_tasks = {}

        for _, task in ipairs(scheduler.tasks) do
            local status = coroutine.status(task)

            if status == "dead" then
                -- Skip dead tasks
            else
                local success, result = coroutine.resume(task)

                if success and coroutine.status(task) ~= "dead" then
                    -- Task is still running, keep it in the queue
                    table.insert(remaining_tasks, task)
                elseif not success then
                    print("Task error:", result)
                else
                    print("Task completed with result:", result or "no result")
                end
            end
        end

        scheduler.tasks = remaining_tasks

        -- Simple visualization
        print("Remaining tasks:", #scheduler.tasks)
    end
end

-- Add some tasks
scheduler.add_task(2, function() return "First task done" end)
scheduler.add_task(3, function() return "Second task done" end)
scheduler.add_task(1, function() return "Quick task done" end)

-- Run the scheduler
scheduler.run()

print_separator()

-- Example 3: Cooperative multitasking with coroutines
print("EXAMPLE 3: COOPERATIVE MULTITASKING")

local function generate_work(name, steps)
    return function()
        for i = 1, steps do
            print(name .. " working on step " .. i .. "/" .. steps)
            coroutine.yield(i / steps * 100) -- yield progress percentage
        end
        return name .. " completed all " .. steps .. " steps"
    end
end

local workers = {
    coroutine.create(generate_work("Worker A", 3)),
    coroutine.create(generate_work("Worker B", 5)),
    coroutine.create(generate_work("Worker C", 2))
}

local all_done = false

while not all_done do
    all_done = true

    for i, worker in ipairs(workers) do
        if coroutine.status(worker) ~= "dead" then
            all_done = false
            local success, progress = coroutine.resume(worker)

            if success then
                if coroutine.status(worker) == "dead" then
                    print("Result: " .. progress) -- on completion, progress is the return value
                else
                    print("Progress: " .. progress .. "%")
                end
            else
                print("Error in worker: " .. progress) -- on error, progress contains error message
            end
        end
    end

    print("--- End of cycle ---")
end

print_separator()

-- Example 4: Coroutine pipelines
print("EXAMPLE 4: COROUTINE PIPELINES")

local function producer(count)
    return coroutine.create(function()
        for i = 1, count do
            coroutine.yield(i)
        end
        return nil -- signal end of data
    end)
end

local function filter(source, predicate)
    return coroutine.create(function()
        while true do
            local success, value = coroutine.resume(source)

            if not success then
                error("Source error: " .. value)
            end

            if value == nil then
                return nil -- end of data
            end

            if predicate(value) then
                coroutine.yield(value)
            end
        end
    end)
end

local function transformer(source, func)
    return coroutine.create(function()
        while true do
            local success, value = coroutine.resume(source)

            if not success then
                error("Source error: " .. value)
            end

            if value == nil then
                return nil -- end of data
            end

            coroutine.yield(func(value))
        end
    end)
end

local function consumer(source)
    while true do
        local success, value = coroutine.resume(source)

        if not success then
            print("Pipeline error: " .. value)
            break
        end

        if value == nil then
            break -- end of data
        end

        print("Consumed value:", value)
    end
end

-- Create a pipeline: producer -> filter -> transformer -> consumer
local p = producer(10)
local f = filter(p, function(x) return x % 2 == 0 end)  -- only even numbers
local t = transformer(f, function(x) return x * 10 end) -- multiply by 10

consumer(t)
