import advanced/project/testing as t
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn add_test() {
  t.add(2, 3) |> should.equal(5)
  t.add(0, 0) |> should.equal(0)
  t.add(-1, 1) |> should.equal(0)
}

pub fn divide_test() {
  t.divide(10, 2) |> should.be_ok |> should.equal(5)
}

pub fn divide_by_zero_test() {
  t.divide(10, 0) |> should.be_error |> should.equal("division by zero")
}

pub fn find_first_test() {
  t.find_first([1, 2, 3, 4], fn(n) { n > 2 }) |> should.be_some |> should.equal(3)
  t.find_first([1, 2, 3], fn(n) { n > 10 }) |> should.be_none
}

pub fn word_count_test() {
  t.word_count("hello world") |> should.equal(2)
  t.word_count("  hello   world  ") |> should.equal(2)
  t.word_count("") |> should.equal(0)
}

pub fn sum_test() {
  t.sum([1, 2, 3, 4, 5]) |> should.equal(15)
  t.sum([]) |> should.equal(0)
}

pub fn product_test() {
  t.product([1, 2, 3, 4, 5]) |> should.equal(120)
  t.product([]) |> should.equal(1)
}
