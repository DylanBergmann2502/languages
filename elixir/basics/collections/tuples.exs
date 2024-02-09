# Like lists, tuples are also immutable.
# Every operation on a tuple returns a new tuple,
# it never changes the given one.
tuple = {:ok, "hello"}

elem(tuple, 1)    # "hello"

tuple_size(tuple) #2

put_elem(tuple, 1, "world") # {:ok, "world"}

tuple = {:foo, :bar, :baz}

Tuple.to_list(tuple) # [:foo, :bar, :baz]
