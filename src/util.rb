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
# Recommended max_line setting: ~40.
#
# @param [String] message the message to type out.
# @param [Integer] max_line the max # of characters in each line.
def type(message, max_line = 0)
  count = 0
  message.split("").each do |i|
    count += 1
    sleep(0.02)
    print i
    if (max_line != 0)
      if (i == " " && count > max_line)
        print "\n"
        count = 0
      end
    end
  end
end
