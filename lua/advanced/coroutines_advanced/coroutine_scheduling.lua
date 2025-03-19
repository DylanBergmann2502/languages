-- coroutine_scheduling.lua

-- Simple scheduler to manage multiple coroutines
local scheduler = {
    tasks = {},      -- List of coroutines to run
    waiting = {},    -- Tasks waiting for time or events
    current_time = 0 -- Virtual time for scheduling
}

-- Add a task to the scheduler
function scheduler:add_task(func)
    local co = coroutine.create(func)
    table.insert(self.tasks, co)
    return co
end

-- Schedule a task to run after specific delay
function scheduler:sleep(time)
    local co = coroutine.running()
    if not co then
        error("Cannot sleep outside of a coroutine")
    end

    self.waiting[co] = self.current_time + time
    return coroutine.yield()
end

-- Main loop to run all coroutines
function scheduler:run()
    while #self.tasks > 0 or next(self.waiting) do
        -- Wake up any waiting tasks whose time has come
        for co, wake_time in pairs(self.waiting) do
            if wake_time <= self.current_time then
                -- Move task back to active list
                table.insert(self.tasks, co)
                self.waiting[co] = nil
            end
        end

        -- Run each active task once
        local active_tasks = #self.tasks
        for i = 1, active_tasks do
            local co = table.remove(self.tasks, 1)
            local success, result = coroutine.resume(co)

            if not success then
                print("Task error: " .. tostring(result))
            elseif coroutine.status(co) ~= "dead" and not self.waiting[co] then
                -- Only re-add if not dead and not waiting
                table.insert(self.tasks, co)
            end
        end

        -- Advance virtual time
        self.current_time = self.current_time + 1

        -- Optional: small real delay to prevent CPU hogging
        -- os.execute("sleep 0.01") -- For non-Windows systems
    end
end

-- Example task: count to 5 with delays
local function counting_task(name, delay)
    for i = 1, 5 do
        print(name .. " counting: " .. i)
        scheduler:sleep(delay)
    end
    print(name .. " finished counting")
end

-- Example task: print messages with priority
local function message_task(msg, repeat_count, delay)
    for i = 1, repeat_count do
        print(string.format("Message %d: %s (time: %d)", i, msg, scheduler.current_time))
        scheduler:sleep(delay)
    end
end

-- Add our tasks to the scheduler with different priorities
scheduler:add_task(function() counting_task("Task A", 2) end)
scheduler:add_task(function() counting_task("Task B", 3) end)
scheduler:add_task(function() message_task("High priority", 3, 1) end)
scheduler:add_task(function() message_task("Low priority", 2, 4) end)

-- Run the scheduler
print("Starting scheduler")
scheduler:run()
print("All tasks completed at time: " .. scheduler.current_time)
