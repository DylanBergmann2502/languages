import gleam/io

// Hex is the package registry for Erlang/Elixir/Gleam — hex.pm
// Gleam packages are added via `gleam add <package>` which writes gleam.toml
// and updates manifest.toml (the lockfile, like Cargo.lock or go.sum)

// --- gleam.toml structure ---
//
// name = "gleam_lessons"
// version = "1.0.0"
//
// [dependencies]
// gleam_stdlib = ">= 1.0.0 and < 2.0.0"   # core stdlib
// gleam_otp   = ">= 1.2.0 and < 2.0.0"   # actors, supervisors
// gleam_erlang = ">= 1.3.0 and < 2.0.0"  # erlang process bindings
//
// [dev_dependencies]
// gleeunit = ">= 1.0.0 and < 2.0.0"       # test framework (dev only)

// --- common packages ---
//
// gleam_otp          — actors, supervisors (OTP)
// gleam_erlang       — process, atom, charlist bindings
// gleam_http         — HTTP types (request/response), target-agnostic
// gleam_httpc        — HTTP client (Erlang target, uses hackney)
// wisp               — web framework (request routing, middleware)
// gleam_json         — JSON encode/decode
// gleam_pgo          — PostgreSQL client
// gleam_crypto       — hashing (md5, sha, hmac)
// gleam_uuid         — UUID generation
// lustre             — front-end framework (compiles to JS)

// --- version constraints ---
//
// ">= 1.0.0 and < 2.0.0"   most common — allows patch and minor updates
// "~> 1.2"                  same as >= 1.2.0 and < 2.0.0
// "~> 1.2.3"                same as >= 1.2.3 and < 1.3.0
// "== 1.2.3"                exact pin

// --- workflow ---
//
// gleam add gleam_json         — adds to [dependencies], updates manifest.toml
// gleam add --dev gleeunit     — adds to [dev_dependencies]
// gleam update                 — update all packages to latest compatible versions
// gleam clean                  — remove build/ cache

// --- manifest.toml ---
//
// auto-generated lockfile — never edit by hand
// commit it to git so your team gets identical versions
// format:  packages = [{ name = "gleam_otp", version = "1.2.0", ... }, ...]

// --- build/ directory ---
//
// build/packages/  — downloaded source of all dependencies
// build/dev/       — compiled output for development target
// build/prod/      — compiled output for --target erlang production builds
// all of it is safe to delete (gleam clean) and regenerate

pub fn main() {
  io.println("current dependencies in this project:")
  // current dependencies in this project:

  let deps = [
    #("gleam_stdlib", ">= 1.0.0 and < 2.0.0"),
    #("gleam_otp", ">= 1.2.0 and < 2.0.0"),
    #("gleam_erlang", ">= 1.3.0 and < 2.0.0"),
  ]

  deps
  |> list_deps

  io.println("")
  io.println("common commands:")
  // common commands:

  let commands = [
    "gleam add gleam_json         -- add a package",
    "gleam add --dev gleeunit     -- add a dev-only package",
    "gleam update                 -- update all packages",
    "gleam clean                  -- clear build cache",
    "gleam build                  -- compile without running",
    "gleam run                    -- compile and run src/gleam_lessons.gleam",
    "gleam run -m path/to/module  -- compile and run a specific module",
    "gleam test                   -- run tests in test/",
    "gleam docs build             -- generate HTML documentation",
    "gleam publish                -- publish to hex.pm",
  ]

  commands
  |> list_items

  io.println("")
  io.println("hex packages done")
  // hex packages done
}

fn list_deps(deps: List(#(String, String))) -> Nil {
  case deps {
    [] -> Nil
    [#(name, version), ..rest] -> {
      io.println("  " <> name <> " = \"" <> version <> "\"")
      list_deps(rest)
    }
  }
}

fn list_items(items: List(String)) -> Nil {
  case items {
    [] -> Nil
    [item, ..rest] -> {
      io.println("  " <> item)
      list_items(rest)
    }
  }
}
