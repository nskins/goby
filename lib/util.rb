# Stores a pair of values.
class Couple

  # @param [Object] first the first object in the pair.
  # @param [Object] second the second object in the pair.
  def initialize(first, second)
    @first = first
    @second = second
  end

  # @param [Couple] rhs the couple on the right.
  def ==(rhs)
    return ((@first == rhs.first) && (@second == rhs.second))
  end

  attr_accessor :first, :second
end

# Simple player input script.
def player_input
  print "> "
  input = gets.chomp
  puts "\n"
  return input
end

# Prints text as if it were being typed.
#
# @param [String] message the message to type out.
def type(message)
  # Processing not required for testing.
  if ENV['TEST']
    print message; return
  end
  
  # Sleep between printing of each char.
  message.split("").each do |i|
    sleep(0.015)
    print i
  end
end
