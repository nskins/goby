require_relative "world_command.rb"
require_relative "Story/introduction.rb"

# Runs the main game loop.
#
# @param [Player] player the player of the game.
def run_driver(player)
  system("clear")

  print_introduction
  describe_tile(player)
  input = player_input

  while (input.casecmp("quit") != 0)
    interpret_command(input, player)
    input = player_input
  end

  #Kills the music after typing quit
  Process.kill(15, $pid)

end
