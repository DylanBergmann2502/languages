-- async_patterns.lua - Asynchronous programming patterns using Lua coroutines

-- Helper function to print a section header
local function print_header(title)
    print("\n" .. string.rep("=", 60))
    print(string.format("%s %s %s", string.rep("-", 5), title, string.rep("-", 5)))
    print(string.rep("=", 60) .. "\n")
end

-- Simple utility to simulate an asynchronous operation
local function async_operation(name, duration)
    return function()
        print(string.format("Starting %s (will take %d seconds)", name, duration))
        -- In a real application, this would be a non-blocking I/O operation
        -- Here we simulate with coroutine.yield
        coroutine.yield(duration)
        return string.format("%s completed successfully", name)
    end
end

-- 1. Basic Promise-like Pattern
print_header("BASIC PROMISE-LIKE PATTERN")

local function create_promise(async_func)
    local co = coroutine.create(async_func)
    local status, duration = coroutine.resume(co)

    return {
        status = "pending",     -- pending, fulfilled, rejected
        result = nil,
        error = nil,

        -- Method to check if promise is complete
        is_done = function(self)
            return self.status ~= "pending"
        end,

        -- Method to update promise state
        update = function(self)
            if self.status ~= "pending" then
                return self.status
            end

            local success, result = coroutine.resume(co)

            if coroutine.status(co) == "dead" then
                if success then
                    self.status = "fulfilled"
                    self.result = result
                else
                    self.status = "rejected"
                    self.error = result
                end
            end

            return self.status
        end,

        -- Method to wait for promise to complete
        await = function(self)
            while self.status == "pending" do
                self:update()
            end

            if self.status == "fulfilled" then
                return self.result
            else
                error(self.error)
            end
        end
    }
end

local promise1 = create_promise(async_operation("Database query", 2))
local promise2 = create_promise(async_operation("API request", 1))

-- Simulate time passing and check promises
for i = 1, 3 do
    print(string.format("\nTick %d:", i))

    print("Promise1 status: " .. promise1:update())
    print("Promise2 status: " .. promise2:update())

    if promise1:is_done() and promise2:is_done() then
        print("\nAll promises completed!")
        print("Promise1 result: " .. promise1.result)
        print("Promise2 result: " .. promise2.result)
        break
    end
end

-- 2. Event Loop Pattern
print_header("EVENT LOOP PATTERN")

local event_loop = {
    time = 0,
    tasks = {},
    callbacks = {}
}

function event_loop:add_task(task_func, callback)
    local co = coroutine.create(task_func)
    local status, delay = coroutine.resume(co)

    if status then
        table.insert(self.tasks, {
            coroutine = co,
            complete_at = self.time + delay,
            callback = callback
        })
    else
        print("Task error: " .. delay)
    end
end

function event_loop:run(max_time)
    while #self.tasks > 0 do
        -- Advance time by one unit
        self.time = self.time + 1
        if max_time and self.time > max_time then break end

        print(string.format("\n--- Tick %d ---", self.time))

        -- Process due tasks
        local remaining_tasks = {}

        for _, task in ipairs(self.tasks) do
            if task.complete_at <= self.time then
                -- Resume the coroutine to get the result
                local success, result = coroutine.resume(task.coroutine)

                if success then
                    -- Call the callback with the result
                    if task.callback then
                        task.callback(result)
                    end
                else
                    print("Task error: " .. result)
                end
            else
                -- Task not due yet, keep it
                table.insert(remaining_tasks, task)
            end
        end

        self.tasks = remaining_tasks
        print(string.format("Remaining tasks: %d", #self.tasks))
    end
end

-- Add some tasks to the event loop
event_loop:add_task(
    async_operation("File read", 2),
    function(result) print("Callback received: " .. result) end
)

event_loop:add_task(
    async_operation("Network request", 3),
    function(result) print("Callback received: " .. result) end
)

-- Run the event loop
event_loop:run(4)

-- 3. Async/Await Pattern
print_header("ASYNC/AWAIT PATTERN")

local async_await = {
    scheduled = {},
    running = nil
}

function async_await:schedule(co)
    table.insert(self.scheduled, co)
end

function async_await:run()
    while #self.scheduled > 0 do
        -- Get next coroutine to run
        self.running = table.remove(self.scheduled, 1)

        -- Run it until it yields or completes
        local success, result = coroutine.resume(self.running)

        if not success then
            print("Error in async function: " .. result)
        end

        -- Reset running coroutine
        self.running = nil
    end
end

function async_await:await(promise)
    local co = self.running

    -- Schedule a function to resume this coroutine when promise completes
    local function check_promise()
        local status = promise:update()

        if status == "pending" then
            -- Reschedule this function
            self:schedule(coroutine.create(check_promise))
        else
            -- Promise completed, resume the waiting coroutine
            self:schedule(co)
        end
    end

    -- Start checking the promise
    self:schedule(coroutine.create(check_promise))

    -- Yield until resumed when promise completes
    coroutine.yield()

    -- Return the promise result or error
    if promise.status == "fulfilled" then
        return promise.result
    else
        error(promise.error)
    end
end

-- Define an async function
local function async_function()
    return coroutine.create(function()
        print("Async function started")

        -- Create some promises
        local db_promise = create_promise(async_operation("Database operation", 2))
        local api_promise = create_promise(async_operation("API operation", 1))

        -- Await the first promise
        print("Awaiting database operation...")
        local db_result = async_await:await(db_promise)
        print("Got result: " .. db_result)

        -- Await the second promise
        print("Awaiting API operation...")
        local api_result = async_await:await(api_promise)
        print("Got result: " .. api_result)

        print("Async function completed")
    end)
end

-- Schedule and run the async function
async_await:schedule(async_function())
async_await:run()

-- 4. Actor Model Pattern
print_header("ACTOR MODEL PATTERN")

local actor_system = {
    actors = {},
    mailboxes = {},
    next_id = 1
}

function actor_system:create_actor(behavior)
    local id = self.next_id
    self.next_id = self.next_id + 1

    self.actors[id] = coroutine.create(function()
        behavior(id)
    end)

    self.mailboxes[id] = {}

    return id
end

function actor_system:send(actor_id, message)
    if not self.mailboxes[actor_id] then
        error("Actor " .. actor_id .. " not found")
    end

    table.insert(self.mailboxes[actor_id], message)
end

function actor_system:receive()
    local actor_id = coroutine.running()

    if #self.mailboxes[actor_id] == 0 then
        -- No messages, yield until one arrives
        coroutine.yield("waiting")
        return self:receive()
    else
        -- Return the next message
        return table.remove(self.mailboxes[actor_id], 1)
    end
end

function actor_system:run(steps)
    for step = 1, steps do
        print("\n--- Step " .. step .. " ---")

        -- Process each actor
        for id, co in pairs(self.actors) do
            if coroutine.status(co) == "suspended" then
                local success, result = coroutine.resume(co)

                if not success then
                    print("Actor " .. id .. " error: " .. result)
                    self.actors[id] = nil
                    self.mailboxes[id] = nil
                end
            elseif coroutine.status(co) == "dead" then
                print("Actor " .. id .. " has terminated")
                self.actors[id] = nil
                self.mailboxes[id] = nil
            end
        end
    end
end

-- Create some actors
local logger_id = actor_system:create_actor(function(self_id)
    while true do
        local message = actor_system:receive()
        print("[Logger] " .. message)
    end
end)

local worker_id = actor_system:create_actor(function(self_id)
    local count = 0

    while count < 3 do
        actor_system:send(logger_id, "Worker processing item " .. count)
        count = count + 1
        coroutine.yield("working")
    end

    actor_system:send(logger_id, "Worker completed all tasks")
end)

-- Run the actor system
actor_system:run(5)

print("\nAsync patterns demonstration completed")
