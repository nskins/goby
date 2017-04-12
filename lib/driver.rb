require_relative "world_command.rb"

module Driver

  include WorldCommand

  # Runs the main game loop.
  #
  # @param [Player] player the player of the game.
  def run_driver(player)

    input = player_input

    while (input.casecmp("quit") != 0)
      interpret_command(input, player)
      input = player_input
    end

  end
end
