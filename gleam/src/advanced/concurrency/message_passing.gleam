import gleam/erlang/process
import gleam/io
import gleam/list
import gleam/otp/actor
import gleam/string

// Gleam message passing — fully typed unlike Elixir's untyped send/receive
// Subject(T) is a typed mailbox: only T values can be sent, only T received
// the type system catches mismatched sends at compile time

// --- request/reply pattern ---

pub type Request {
  Echo(reply_to: process.Subject(String), text: String)
  Reverse(reply_to: process.Subject(String), text: String)
  Quit
}

fn handle_echo(_state: Nil, msg: Request) -> actor.Next(Nil, Request) {
  case msg {
    Echo(reply_to, text) -> {
      process.send(reply_to, "echo: " <> text)
      actor.continue(Nil)
    }
    Reverse(reply_to, text) -> {
      process.send(reply_to, string.reverse(text))
      actor.continue(Nil)
    }
    Quit -> actor.stop()
  }
}

// --- multiple subjects with Selector ---

pub type AnyMsg {
  FromInt(Int)
  FromString(String)
}

pub fn main() {
  // basic fire-and-forget
  let subject: process.Subject(String) = process.new_subject()
  let sender = process.spawn(fn() { process.send(subject, "ping") })
  io.println("sender: " <> string.inspect(sender))
  // sender: <0.83.0>

  let msg = process.receive(subject, 100)
  io.println(string.inspect(msg))
  // Ok("ping")

  // request/reply — caller creates a reply subject and embeds it in the request
  let assert Ok(started) =
    actor.new(Nil)
    |> actor.on_message(handle_echo)
    |> actor.start

  let echo_actor = started.data

  // process.call handles the reply subject plumbing for you:
  //   creates a reply subject, builds the message, sends it, waits for response
  let reply = process.call(echo_actor, 100, fn(s) { Echo(s, "hello world") })
  io.println(reply)
  // echo: hello world

  let reversed = process.call(echo_actor, 100, fn(s) { Reverse(s, "gleam") })
  io.println(reversed)
  // maelg

  // Selector — receive from multiple subjects, get the first that arrives
  let int_subject = process.new_subject()
  let str_subject = process.new_subject()

  // spawn senders
  process.spawn(fn() {
    process.sleep(5)
    process.send(int_subject, 42)
  })
  process.spawn(fn() {
    process.sleep(10)
    process.send(str_subject, "hello")
  })

  // select_map — add subject with a mapping fn to unify types
  let selector =
    process.new_selector()
    |> process.select_map(int_subject, FromInt)
    |> process.select_map(str_subject, FromString)

  // receive whichever arrives first
  let first = process.selector_receive(selector, 50)
  io.println(string.inspect(first))
  // Ok(FromInt(42))

  let second = process.selector_receive(selector, 50)
  io.println(string.inspect(second))
  // Ok(FromString("hello"))

  // send multiple messages, receive in order
  let batch_subject: process.Subject(Int) = process.new_subject()
  list.each([10, 20, 30], fn(n) { process.send(batch_subject, n) })

  let a = process.receive(batch_subject, 10)
  let b = process.receive(batch_subject, 10)
  let c = process.receive(batch_subject, 10)
  io.println(string.inspect(#(a, b, c)))
  // #(Ok(10), Ok(20), Ok(30))

  // send_after — deliver a message after a delay (milliseconds)
  let delayed_subject: process.Subject(String) = process.new_subject()
  let _timer = process.send_after(delayed_subject, 20, "delayed!")
  let early = process.receive(delayed_subject, 5)
  io.println(string.inspect(early))
  // Error(Nil)  (nothing arrived yet)

  let late = process.receive(delayed_subject, 50)
  io.println(string.inspect(late))
  // Ok("delayed!")

  // shut down the echo actor cleanly
  process.send(echo_actor, Quit)

  io.println("message passing done")
  // message passing done
}
