require 'goby'

module Goby

  # Provides method(s) for running the main game loop.
  module Driver

    include WorldCommand

    # Runs the main game loop.
    #
    # @param [Player] player the player of the game.
    def run_driver(player)

      input = player_input prompt: '> '

      while (input.casecmp("quit").nonzero?)
        interpret_command(input, player)
        input = player_input prompt: '> '
      end

    end
  end

end
