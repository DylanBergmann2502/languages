-- producer_consumer.lua
-- Demonstrates different producer-consumer patterns using Lua coroutines

-- Helper function to print section headers
local function print_section(title)
    print("\n" .. string.rep("=", 60))
    print(string.format("  %s", title))
    print(string.rep("=", 60))
end

-------------------------------------------------------------------------
print_section("BASIC PRODUCER-CONSUMER")

-- Basic producer coroutine that generates values
local function create_producer(count, delay)
    return coroutine.create(function()
        for i = 1, count do
            print("Producer: generating item " .. i)
            coroutine.yield(i)

            -- Simulate work
            if delay then
                print("Producer: sleeping...")
                coroutine.yield("sleep")
            end
        end
        return nil     -- Signal end of production
    end)
end

-- Basic consumer that processes values from a producer
local function consume(producer)
    while true do
        local status, value = coroutine.resume(producer)

        if not status then
            error("Producer error: " .. value)
        end

        if value == nil then
            print("Consumer: production ended")
            break
        elseif value == "sleep" then
            -- Producer is sleeping, continue
        else
            print("Consumer: processing item " .. value)
        end
    end
end

local producer = create_producer(5, true)
consume(producer)

-------------------------------------------------------------------------
print_section("BUFFERED PRODUCER-CONSUMER")

-- Buffer manager to handle inter-coroutine communication
local function create_buffer(capacity)
    local buffer = {
        items = {},
        capacity = capacity or 3,
        count = 0
    }

    function buffer:put(item)
        while self.count >= self.capacity do
            print("Buffer full, producer waiting...")
            coroutine.yield("buffer_full")
        end

        table.insert(self.items, item)
        self.count = self.count + 1
        print(string.format("Buffer: item %s added [%d/%d]",
            tostring(item), self.count, self.capacity))
        return true
    end

    function buffer:get()
        while self.count <= 0 do
            print("Buffer empty, consumer waiting...")
            coroutine.yield("buffer_empty")
        end

        local item = table.remove(self.items, 1)
        self.count = self.count - 1
        print(string.format("Buffer: item %s removed [%d/%d]",
            tostring(item), self.count, self.capacity))
        return item
    end

    return buffer
end

-- Advanced producer that works with a buffer
local function buffered_producer(buffer, items)
    return coroutine.create(function()
        for _, item in ipairs(items) do
            print("Producer: generating " .. item)
            buffer:put(item)

            -- Simulate varying production speeds
            if math.random() > 0.5 then
                print("Producer: taking a break...")
                coroutine.yield("producer_break")
            end
        end
        return "production_complete"
    end)
end

-- Advanced consumer that works with a buffer
local function buffered_consumer(buffer, name)
    return coroutine.create(function()
        while true do
            local item = buffer:get()
            print(name .. ": processing " .. item)

            -- Simulate varying consumption speeds
            if math.random() > 0.3 then
                print(name .. ": taking a break...")
                coroutine.yield("consumer_break")
            end
        end
    end)
end

-- Scheduler to coordinate producer and consumers
local function run_buffered_system(producer, consumers, max_steps)
    local steps = 0
    local producer_done = false

    while not producer_done or steps < max_steps do
        steps = steps + 1
        print("\n--- Step " .. steps .. " ---")

        if not producer_done then
            local status, result = coroutine.resume(producer)

            if not status then
                print("Producer error: " .. result)
                break
            end

            if result == "production_complete" then
                print("Producer has finished")
                producer_done = true
            end
        end

        -- Run each consumer
        for i, consumer in ipairs(consumers) do
            if coroutine.status(consumer) ~= "dead" then
                local status, result = coroutine.resume(consumer)

                if not status and result ~= "attempt to yield from outside a coroutine" then
                    print("Consumer " .. i .. " error: " .. result)
                end
            end
        end

        if steps >= max_steps then
            print("Reached maximum steps")
            break
        end
    end
end

-- Set random seed for consistent results
math.randomseed(os.time())

-- Create a buffer and producer/consumer system
local buffer = create_buffer(2)     -- Buffer capacity of 2
local prod = buffered_producer(buffer, { "A", "B", "C", "D", "E" })
local cons1 = buffered_consumer(buffer, "Consumer 1")
local cons2 = buffered_consumer(buffer, "Consumer 2")

run_buffered_system(prod, { cons1, cons2 }, 20)

-------------------------------------------------------------------------
print_section("PIPELINE PRODUCER-CONSUMER")

-- Producer stage generates data
local function pipeline_producer(items)
    return coroutine.create(function()
        for _, item in ipairs(items) do
            print("Producer: sending " .. item)
            coroutine.yield(item)
        end
        return nil     -- End of stream
    end)
end

-- Filter stage processes and may filter items
local function pipeline_filter(source, predicate)
    return coroutine.create(function()
        while true do
            local status, item = coroutine.resume(source)

            if not status then
                error("Pipeline error: " .. item)
            end

            if item == nil then
                -- End of stream, propagate
                return nil
            end

            -- Only yield items that pass the predicate
            if predicate(item) then
                print("Filter: passing " .. item)
                coroutine.yield(item)
            else
                print("Filter: dropping " .. item)
            end
        end
    end)
end

-- Transformer stage modifies items
local function pipeline_transformer(source, transform_func)
    return coroutine.create(function()
        while true do
            local status, item = coroutine.resume(source)

            if not status then
                error("Pipeline error: " .. item)
            end

            if item == nil then
                -- End of stream, propagate
                return nil
            end

            -- Transform the item
            local transformed = transform_func(item)
            print("Transformer: " .. item .. " -> " .. transformed)
            coroutine.yield(transformed)
        end
    end)
end

-- Consumer stage processes final items
local function pipeline_consumer(source)
    while true do
        local status, item = coroutine.resume(source)

        if not status then
            error("Pipeline error: " .. item)
        end

        if item == nil then
            -- End of stream
            print("Consumer: end of pipeline")
            break
        end

        print("Consumer: final processing of " .. item)
    end
end

-- Create a pipeline: producer -> filter -> transformer -> consumer
local source_data = { "123", "abc", "456", "def", "789" }
local prod_stage = pipeline_producer(source_data)

local filter_stage = pipeline_filter(prod_stage, function(item)
    -- Only allow items with numbers
    return string.match(item, "%d") ~= nil
end)

local transform_stage = pipeline_transformer(filter_stage, function(item)
    -- Add prefix to passed items
    return "ITEM-" .. item
end)

-- Run the pipeline
pipeline_consumer(transform_stage)

-------------------------------------------------------------------------
print_section("MULTI-PRIORITY PRODUCER-CONSUMER")

-- Priority queue implementation
local function create_priority_queue()
    local queue = {
        -- Table of queues, one per priority level
        queues = {},
        -- Total number of items across all priorities
        size = 0
    }

    function queue:put(item, priority)
        priority = priority or 5     -- Default priority (middle)

        -- Ensure queue for this priority exists
        if not self.queues[priority] then
            self.queues[priority] = {}
        end

        -- Add item to appropriate queue
        table.insert(self.queues[priority], item)
        self.size = self.size + 1

        print(string.format("Queue: added item %s with priority %d (total: %d)",
            tostring(item), priority, self.size))
    end

    function queue:get()
        if self.size == 0 then
            return nil, "queue_empty"
        end

        -- Find highest priority non-empty queue
        for priority = 1, 10 do
            local pq = self.queues[priority]
            if pq and #pq > 0 then
                local item = table.remove(pq, 1)
                self.size = self.size - 1

                print(string.format("Queue: removed item %s with priority %d (total: %d)",
                    tostring(item), priority, self.size))
                return item, priority
            end
        end

        return nil, "queue_empty"     -- Should never reach here if size > 0
    end

    return queue
end

-- Priority producer
local function priority_producer(queue)
    return coroutine.create(function()
        -- Generate items with different priorities
        local items = {
            { value = "Critical Bug",      priority = 1 },
            { value = "Feature Request",   priority = 5 },
            { value = "Documentation",     priority = 8 },
            { value = "Security Issue",    priority = 2 },
            { value = "Performance Issue", priority = 3 },
            { value = "UI Enhancement",    priority = 6 },
            { value = "Refactoring Task",  priority = 7 },
            { value = "Critical Outage",   priority = 1 }
        }

        for _, item in ipairs(items) do
            print("Producer: generating " .. item.value)
            queue:put(item.value, item.priority)
            coroutine.yield("produced")
        end

        return "all_items_produced"
    end)
end

-- Priority consumer
local function priority_consumer(queue)
    return coroutine.create(function()
        while true do
            local item, priority = queue:get()

            if not item then
                print("Consumer: queue is empty, waiting...")
                coroutine.yield("waiting")
            else
                print(string.format("Consumer: processing %s (priority %d)",
                    item, priority))

                -- Simulate processing time based on priority
                local work_cycles = 11 - priority     -- Higher priority = less work time
                for i = 1, work_cycles do
                    print(string.format("Consumer: working on %s (%d/%d)",
                        item, i, work_cycles))
                    coroutine.yield("processing")
                end

                print("Consumer: completed " .. item)
            end
        end
    end)
end

-- Run the priority queue system
local function run_priority_system(producer, consumer, max_steps)
    local steps = 0
    local producer_done = false

    while steps < max_steps do
        steps = steps + 1
        print("\n--- Priority Step " .. steps .. " ---")

        -- Run producer if not done
        if not producer_done then
            local status, result = coroutine.resume(producer)

            if not status then
                print("Producer error: " .. result)
                break
            end

            if result == "all_items_produced" then
                producer_done = true
                print("Producer has finished adding all items")
            end
        end

        -- Run consumer
        local status, result = coroutine.resume(consumer)

        if not status then
            print("Consumer error: " .. result)
            break
        end
    end

    print("Priority system finished after " .. steps .. " steps")
end

-- Create and run priority system
local pq = create_priority_queue()
local priority_prod = priority_producer(pq)
local priority_cons = priority_consumer(pq)

run_priority_system(priority_prod, priority_cons, 30)

print("\nProducer-consumer patterns demonstration completed")
