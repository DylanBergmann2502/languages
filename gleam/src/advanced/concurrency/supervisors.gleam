import gleam/erlang/process
import gleam/io
import gleam/otp/actor
import gleam/otp/static_supervisor as supervisor
import gleam/otp/supervision
import gleam/string

// Supervisors — the fault-tolerance backbone of OTP
// a supervisor watches child processes and restarts them if they crash
// you know this from Elixir/Phoenix: Supervisor, GenServer, application.ex
//
// Three restart strategies:
//   OneForOne  — restart only the crashed child (most common)
//   OneForAll  — restart all children when any one crashes
//   RestForOne — restart the crashed child and all children started after it

// --- counter actor (same as actors.gleam) ---

pub type CounterMsg {
  Add(Int)
  GetCount(reply_to: process.Subject(Int))
  Stop
}

fn handle_counter(state: Int, msg: CounterMsg) -> actor.Next(Int, CounterMsg) {
  case msg {
    Add(n) -> actor.continue(state + n)
    GetCount(reply_to) -> {
      process.send(reply_to, state)
      actor.continue(state)
    }
    Stop -> actor.stop()
  }
}

fn start_counter() -> Result(
  actor.Started(process.Subject(CounterMsg)),
  actor.StartError,
) {
  actor.new(0)
  |> actor.on_message(handle_counter)
  |> actor.start
}

// --- logger actor ---

pub type LogMsg {
  Log(String)
  GetLog(reply_to: process.Subject(String))
}

fn handle_logger(
  lines: List(String),
  msg: LogMsg,
) -> actor.Next(List(String), LogMsg) {
  case msg {
    Log(line) -> actor.continue([line, ..lines])
    GetLog(reply_to) -> {
      let combined = case lines {
        [] -> "(empty)"
        _ -> string.join(lines, ", ")
      }
      process.send(reply_to, combined)
      actor.continue(lines)
    }
  }
}

fn start_logger() -> Result(
  actor.Started(process.Subject(LogMsg)),
  actor.StartError,
) {
  actor.new([])
  |> actor.on_message(handle_logger)
  |> actor.start
}

pub fn main() {
  // supervision.worker — wrap a start function as a supervised child
  // Permanent restart (default): always restart on crash
  // Transient: only restart on abnormal exit
  // Temporary: never restart
  let counter_spec = supervision.worker(start_counter)
  let logger_spec = supervision.worker(start_logger)

  // static_supervisor.new — builder for the supervisor
  // OneForOne: only the crashed child is restarted
  let assert Ok(sup) =
    supervisor.new(supervisor.OneForOne)
    |> supervisor.add(counter_spec)
    |> supervisor.add(logger_spec)
    |> supervisor.start

  io.println("supervisor started")
  // supervisor started

  io.println("supervisor pid: " <> string.inspect(sup.pid))
  // supervisor pid: <0.84.0>

  io.println(string.inspect(process.is_alive(sup.pid)))
  // True

  // start children directly (outside the supervisor) to interact with them
  let assert Ok(counter_started) = start_counter()
  let counter = counter_started.data

  let assert Ok(logger_started) = start_logger()
  let logger = logger_started.data

  // use counter
  process.send(counter, Add(10))
  process.send(counter, Add(5))
  let count = process.call(counter, 100, GetCount)
  io.println("count: " <> string.inspect(count))
  // count: 15

  // use logger
  process.send(logger, Log("started"))
  process.send(logger, Log("processing"))
  let log = process.call(logger, 100, GetLog)
  io.println("log: " <> log)
  // log: processing, started

  // restart strategies explained (can't demo crashes safely in a lesson):
  //
  //   OneForOne  — crash in child A: only A restarts, B/C keep running
  //   OneForAll  — crash in child A: A, B, C all restart together
  //   RestForOne — crash in child B: B and C restart, A keeps running
  //
  // restart_tolerance: max N crashes within T seconds before supervisor itself exits
  let _tolerant =
    supervisor.new(supervisor.OneForOne)
    |> supervisor.restart_tolerance(intensity: 5, period: 10)

  // Transient — restart only on abnormal exit (actor.stop_abnormal)
  // useful for tasks that are expected to finish normally
  let transient_spec =
    supervision.worker(start_counter)
    |> supervision.restart(supervision.Transient)

  let _temp_spec =
    supervision.worker(start_counter)
    |> supervision.restart(supervision.Temporary)

  let assert Ok(_sup2) =
    supervisor.new(supervisor.OneForOne)
    |> supervisor.add(transient_spec)
    |> supervisor.start

  io.println("transient supervisor started")
  // transient supervisor started

  // supervision trees — supervisors can supervise other supervisors
  // the child supervisor itself is a worker in the parent
  let inner_builder =
    supervisor.new(supervisor.OneForOne)
    |> supervisor.add(supervision.worker(start_counter))

  let assert Ok(_root) =
    supervisor.new(supervisor.OneForOne)
    |> supervisor.add(supervisor.supervised(inner_builder))
    |> supervisor.start

  io.println("nested supervision tree started")
  // nested supervision tree started

  // clean up standalone actors
  process.send(counter, Stop)
  process.send(logger, GetLog(process.new_subject()))

  io.println("supervisors done")
  // supervisors done
}
