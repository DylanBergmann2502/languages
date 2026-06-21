import gleam/erlang/process
import gleam/io
import gleam/string

pub fn main() {
  // Gleam runs on the BEAM (Erlang VM) — every concurrent unit is a process
  // processes are NOT OS threads — they're cheap, isolated, message-passing units
  // the BEAM schedules them across all CPU cores automatically

  // process.self() — get the PID of the current process
  let me = process.self()
  io.println("current pid: " <> string.inspect(me))
  // current pid: <0.82.0>  (exact number varies)

  // process.spawn — start a new linked process running a function
  // linked means: if the child crashes, the parent gets an exit signal too
  let child_pid =
    process.spawn(fn() {
      io.println("hello from child process")
      // hello from child process
    })

  io.println("child pid: " <> string.inspect(child_pid))
  // child pid: <0.83.0>

  io.println(string.inspect(process.is_alive(child_pid)))
  // True or False depending on scheduling — child may still be alive

  // process.spawn_unlinked — start without linking
  // crash in child does NOT propagate to parent
  let _unlinked =
    process.spawn_unlinked(fn() {
      io.println("unlinked process running")
      // unlinked process running
    })

  // sleep to let spawned processes run before main exits
  process.sleep(10)

  // Subject — a typed channel between processes
  // new_subject() creates a mailbox slot owned by the current process
  let subject = process.new_subject()

  // send to the subject from a spawned process
  let sender_pid =
    process.spawn(fn() { process.send(subject, "message from spawned process") })

  io.println("sender pid: " <> string.inspect(sender_pid))
  // sender pid: <0.84.0>

  // receive — wait up to N milliseconds for a message on the subject
  let result = process.receive(subject, 100)
  io.println(string.inspect(result))
  // Ok("message from spawned process")

  // timeout case — nothing arrives in time
  let empty_subject: process.Subject(Int) = process.new_subject()
  let timed_out = process.receive(empty_subject, 1)
  io.println(string.inspect(timed_out))
  // Error(Nil)

  // process.monitor — watch a process, get notified when it exits
  let watched = process.spawn(fn() { process.sleep(5) })
  let monitor = process.monitor(watched)

  // select_specific_monitor to receive the Down message
  let down_selector =
    process.new_selector()
    |> process.select_specific_monitor(monitor, fn(down) { down })

  process.sleep(20)
  let down_msg = process.selector_receive(down_selector, 50)
  case down_msg {
    Ok(_) -> io.println("process exited — Down message received")
    Error(Nil) -> io.println("no Down message yet")
  }
  // process exited — Down message received

  io.println("main process done")
  // main process done
}
