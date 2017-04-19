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

# Simple player input script.
#
# @param [Boolean] return_string mark true if input is either 'y' or 'n' and a response should be returned.
# @param [String] prompt the prompt for the user to input information (defaults as '> ').
def player_input(return_string: false, prompt: '> ')

  begin
    # When using Readline, rspec actually prompts the user for input, freezing the tests.
    if(ENV['TEST'] == 'rspec')
      input = gets.chomp
    else
      input = Readline.readline(prompt, false)
      puts "\n"
    end
  rescue Interrupt => e
    puts "The game was interrupted."
  end

  if ((input.size > 1) and (input != Readline::HISTORY.to_a[-1]))
    Readline::HISTORY.push(input)
  end

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

# Serializes the player object into a YAML file and saves it
#
# @param [Player] player the player object to be saved
def save_game(player)
  player_data = YAML::dump(player)
  File.open("player.yaml", "w") do |file|
    file.puts player_data
  end
  print "Successfully saved the game!\n\n"
  return
end

# Reads and check the save file and parses into the player object
#
#
def load_game
  begin
    player = YAML.load_file("player.yaml")
    return player
  rescue
    return nil
  end
end
