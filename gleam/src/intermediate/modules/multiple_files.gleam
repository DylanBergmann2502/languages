// this file imports from user.gleam in the same directory
// demonstrating how modules split across files work in practice

import gleam/io
import gleam/list
import gleam/string
import intermediate/modules/user.{type Role, type User, Admin, Guest, Member}

pub fn describe(u: User) -> String {
  let role_str = case user.role(u) {
    Admin -> "admin"
    Member -> "member"
    Guest -> "guest"
  }
  user.name(u)
  <> " (age "
  <> string.inspect(user.age(u))
  <> ", "
  <> role_str
  <> ")"
}

pub fn main() {
  // constructing a User via the module's public constructor
  let dylan = user.new("Dylan", 30, Admin)
  io.println(user.greet(dylan))
  // Hello, Dylan!

  io.println(string.inspect(user.is_admin(dylan)))
  // True

  io.println(describe(dylan))
  // Dylan (age 30, admin)

  // using the safe constructor — returns Result
  let alice = user.new_safe("Alice", 25, Member)
  io.println(string.inspect(alice))
  // Ok(User("Alice", 25, Member))

  let bad_age = user.new_safe("Bob", -5, Guest)
  io.println(string.inspect(bad_age))
  // Error("invalid age: -5")

  let empty_name = user.new_safe("  ", 20, Guest)
  io.println(string.inspect(empty_name))
  // Error("name cannot be empty")

  // Role was imported unqualified — can use Admin/Member/Guest directly
  let roles: List(Role) = [Admin, Member, Guest]
  io.println(string.inspect(roles))
  // [Admin, Member, Guest]

  // user.User type was imported — can annotate with it
  let users: List(User) = [
    user.new("Charlie", 22, Member),
    user.new("Dana", 35, Admin),
  ]
  let summaries =
    list.map(users, fn(u) {
      user.name(u) <> " is " <> string.inspect(user.age(u))
    })
  io.println(string.join(summaries, ", "))
  // Charlie is 22, Dana is 35
}
