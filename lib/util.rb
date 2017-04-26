require 'yaml'
require 'readline'

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

# Simple player input script. Maintains command history for
# commands longer than one character.
def player_input

  # When using Readline, rspec actually prompts the user for input, freezing the tests.
  input = (ENV['TEST'] == 'rspec') ? gets.chomp : Readline.readline("> ", false)
  print "\n"

  if (input.size > 1 and input != Readline::HISTORY.to_a[-1])
    Readline::HISTORY.push(input)
  end

  return input
end

# Prints text as if it were being typed.
#
# @param [String] message the message to type out.
def type(message)

  # Amount of time to sleep between printing character.
  time = ENV['TEST'] ? 0 : 0.015

  # Sleep between printing of each char.
  message.split("").each do |i|
    sleep(time) if time.nonzero?
    print i
  end
end

# Serializes the player object into a YAML file and saves it
# 
# @param [Player] player the player object to be saved
def save_game(player, filename)
  player_data = YAML::dump(player)
  File.open(filename, "w") do |file|
    file.puts player_data
  end
  print "Successfully saved the game!\n\n"
  return
end

# Reads and check the save file and parses into the player object
# 
#
def load_game(filename)
  begin
    player = YAML.load_file(filename)
    return player
  rescue
    return nil
  end
end