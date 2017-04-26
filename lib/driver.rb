require_relative "world_command.rb"

# Runs the main game loop.
#
# @param [Player] player the player of the game.
def run_driver(player)

  input = player_input prompt: '> '

  while (input.casecmp("quit") != 0)
    interpret_command(input, player)
    input = player_input prompt: '> '
  end

end
