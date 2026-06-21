// this module is imported by multiple_files.gleam and opaque_types.gleam
// it demonstrates: pub type, pub fn, opaque type, private items

import gleam/string

// pub type — exported, other modules can construct and pattern match on it
pub type Role {
  Admin
  Member
  Guest
}

// opaque type — exported but internals are hidden
// other modules can only use it through the functions we provide
pub opaque type User {
  User(name: String, age: Int, role: Role)
}

// pub fn — exported constructor (the only way to build a User from outside)
pub fn new(name: String, age: Int, role: Role) -> User {
  User(name: string.trim(name), age: age, role: role)
}

// pub fn — exported accessors (since the fields are hidden)
pub fn name(user: User) -> String {
  user.name
}

pub fn age(user: User) -> Int {
  user.age
}

pub fn role(user: User) -> Role {
  user.role
}

pub fn is_admin(user: User) -> Bool {
  user.role == Admin
}

pub fn greet(user: User) -> String {
  "Hello, " <> user.name <> "!"
}

// private fn — not visible outside this module
fn validate_age(age: Int) -> Bool {
  age >= 0 && age <= 150
}

pub fn new_safe(name: String, age: Int, role: Role) -> Result(User, String) {
  case validate_age(age) {
    False -> Error("invalid age: " <> string.inspect(age))
    True ->
      case string.length(string.trim(name)) == 0 {
        True -> Error("name cannot be empty")
        False -> Ok(User(name: string.trim(name), age: age, role: role))
      }
  }
}
