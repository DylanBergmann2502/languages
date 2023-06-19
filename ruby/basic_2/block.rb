# Use with yield
def logger
  yield
end

logger { puts 'hello from the block' }
#=> hello from the block

logger do
  p [1, 2, 3]
end

#=> [1,2,3]

################################################################
def double_vision
  yield
  yield
end

double_vision { puts 'How many fingers am I holding up?' }
#=> How many fingers am I holding up?
#=> How many fingers am I holding up?

################################################################
def say_something
  yield #('Hello') # No arguments are passed to yield
end

say_something do |word| # But the block expects one argument to be passed in
  puts "And then I said: #{word}"
end
#=> And then I said:

################################################################
def mad_libs
  yield('cool', 'beans', 'burrito') # 3 arguments are passed to yield
end

mad_libs do |adjective, noun| # But the block only takes 2 parameters
  puts "I said #{adjective} #{noun}!"
end
#=> I said cool beans!

################################################################
def awesome_method
  hash = {a: 'apple', b: 'banana', c: 'cookie'}

  hash.each do |key, value|
    yield key, value
  end
end

awesome_method { |key, value| puts "#{key}: #{value}" }
#=> a: apple
#=> b: banana
#=> c: cookie

################################################################
def maybe_block
  if block_given?
    puts 'block party'
  end
  puts 'executed regardless'
end

maybe_block
# => executed regardless

maybe_block {} # {} is just an empty block
# => block party
# => executed regardless

################################################################
# Capturing blocks
