import gleam/io
import gleam/string

pub type Shape {
  Circle(radius: Float)
  Rectangle(width: Float, height: Float)
}

pub type Season {
  Spring
  Summer
  Autumn
  Winter
}

fn describe_season(season: Season) -> Nil {
  case season {
    Spring | Summer -> io.println("Warm: " <> string.inspect(season))
    Autumn | Winter -> io.println("Cold: " <> string.inspect(season))
  }
}

fn show_result(val: Result(Int, String)) -> Nil {
  case val {
    Ok(n) as r ->
      io.println("Got " <> string.inspect(n) <> " from " <> string.inspect(r))
    Error(_) -> io.println("Error")
  }
}

fn show_wrapped(wrapped: Result(Shape, String)) -> Nil {
  case wrapped {
    Ok(Circle(r)) ->
      io.println("Circle inside Ok, radius: " <> string.inspect(r))
    Ok(Rectangle(..)) -> io.println("Rectangle inside Ok")
    Error(e) -> io.println("Error: " <> e)
  }
}

fn describe_shape(shape: Shape) -> Nil {
  case shape {
    Circle(r) -> io.println("Circle with radius " <> string.inspect(r))
    Rectangle(w, h) ->
      io.println("Rectangle " <> string.inspect(w) <> "x" <> string.inspect(h))
  }
}

pub fn main() {
  // case is the primary pattern matching construct
  // it is exhaustive — the compiler forces you to handle all variants
  let day = "Monday"
  case day {
    "Saturday" | "Sunday" -> io.println("Weekend!")
    _ -> io.println("Weekday")
  }
  // Weekday

  // matching on Int
  let score = 85
  let grade = case score {
    n if n >= 90 -> "A"
    n if n >= 80 -> "B"
    n if n >= 70 -> "C"
    _ -> "F"
  }
  io.println(grade)
  // B

  // matching on custom types — destructure the constructor
  // use a helper fn so the compiler sees the full Shape type at the call site
  describe_shape(Rectangle(width: 4.0, height: 3.0))
  // Rectangle 4.0x3.0

  describe_shape(Circle(radius: 5.0))
  // Circle with radius 5.0

  // matching on tuples
  let point = #(0, 1)
  case point {
    #(0, 0) -> io.println("origin")
    #(0, _) -> io.println("on y-axis")
    #(_, 0) -> io.println("on x-axis")
    #(x, y) ->
      io.println("point at " <> string.inspect(x) <> "," <> string.inspect(y))
  }
  // on y-axis

  // matching on lists
  let nums = [1, 2, 3]
  case nums {
    [] -> io.println("empty")
    [x] -> io.println("one element: " <> string.inspect(x))
    [x, y, ..] ->
      io.println(
        "starts with " <> string.inspect(x) <> " and " <> string.inspect(y),
      )
  }
  // starts with 1 and 2

  // matching all variants of a custom type — exhaustive, no wildcard needed
  describe_season(Summer)
  // Warm: Summer

  describe_season(Winter)
  // Cold: Winter

  // `as` on a single pattern — bind the whole value while destructuring inside
  show_result(Ok(42))
  // Got 42 from Ok(42)

  show_result(Error("oops"))
  // Error

  // nested pattern matching — match on Result containing a Shape
  show_wrapped(Ok(Circle(radius: 2.0)))
  // Circle inside Ok, radius: 2.0

  show_wrapped(Ok(Rectangle(width: 3.0, height: 4.0)))
  // Rectangle inside Ok

  show_wrapped(Error("bad"))
  // Error: bad
}
