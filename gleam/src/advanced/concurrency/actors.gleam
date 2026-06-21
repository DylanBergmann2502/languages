import gleam/erlang/process
import gleam/io
import gleam/otp/actor
import gleam/string

// Actor — Gleam's typed alternative to Erlang's gen_server
// handles messages one at a time (sequential), holds mutable state across messages
// the state never leaves the actor process — only messages cross the boundary

// message type: everything this actor can receive
pub type CounterMsg {
  Increment
  Decrement
  Reset
  Get(reply_to: process.Subject(Int))
}

// message handler — called for each incoming message
// returns actor.Next which tells the actor what to do next
fn handle_counter(state: Int, msg: CounterMsg) -> actor.Next(Int, CounterMsg) {
  case msg {
    Increment -> actor.continue(state + 1)
    Decrement -> actor.continue(state - 1)
    Reset -> actor.continue(0)
    Get(reply_to) -> {
      process.send(reply_to, state)
      actor.continue(state)
    }
  }
}

// a stack actor to show Push/Pop and actor.stop()
pub type StackMsg {
  Push(String)
  Pop(reply_to: process.Subject(Result(String, Nil)))
  Shutdown
}

fn handle_stack(
  stack: List(String),
  msg: StackMsg,
) -> actor.Next(List(String), StackMsg) {
  case msg {
    Push(item) -> actor.continue([item, ..stack])
    Pop(reply_to) ->
      case stack {
        [] -> {
          process.send(reply_to, Error(Nil))
          actor.continue([])
        }
        [top, ..rest] -> {
          process.send(reply_to, Ok(top))
          actor.continue(rest)
        }
      }
    Shutdown -> actor.stop()
  }
}

pub fn main() {
  // actor.new(initial_state) — builder starting point
  // actor.on_message(handler) — set message handler
  // actor.start — spawn the actor, returns Result(Started(Subject(Msg)), StartError)
  let assert Ok(started) =
    actor.new(0)
    |> actor.on_message(handle_counter)
    |> actor.start

  // started.data is the Subject — the typed channel to send messages to the actor
  let counter = started.data

  // fire-and-forget sends (no reply expected)
  process.send(counter, Increment)
  process.send(counter, Increment)
  process.send(counter, Increment)
  process.send(counter, Decrement)

  // call-style: send Get with a reply subject, wait for the response
  // process.call sends a message and blocks until a reply arrives
  let value = process.call(counter, 100, Get)
  io.println("counter value: " <> string.inspect(value))
  // counter value: 2

  process.send(counter, Reset)
  let after_reset = process.call(counter, 100, Get)
  io.println("after reset: " <> string.inspect(after_reset))
  // after reset: 0

  // actor.send is a convenience re-export of process.send
  actor.send(counter, Increment)
  actor.send(counter, Increment)

  let v2 = actor.call(counter, waiting: 100, sending: Get)
  io.println("via actor.call: " <> string.inspect(v2))
  // via actor.call: 2

  // started.pid — the Pid of the actor process
  io.println("actor pid: " <> string.inspect(started.pid))
  // actor pid: <0.84.0>

  io.println(string.inspect(process.is_alive(started.pid)))
  // True

  // stack actor: Push/Pop with reply, Shutdown to stop cleanly
  let assert Ok(stack_started) =
    actor.new([])
    |> actor.on_message(handle_stack)
    |> actor.start

  let stack = stack_started.data
  process.send(stack, Push("a"))
  process.send(stack, Push("b"))
  process.send(stack, Push("c"))

  let top = process.call(stack, 100, Pop)
  io.println(string.inspect(top))
  // Ok("c")

  let next = process.call(stack, 100, Pop)
  io.println(string.inspect(next))
  // Ok("b")

  // actor.stop() exits the actor normally — no more messages processed
  process.send(stack, Shutdown)
  process.sleep(10)
  io.println(string.inspect(process.is_alive(stack_started.pid)))
  // False
}
