require 'goby'

module Goby

  include Music
  include WorldCommand

  # Runs the main game loop.
  #
  # @param [Player] player the player of the game.
  def run_driver(player)
    while (run_turn(player)); end
    stop_music
  end

  private

    # Clear the terminal and display the minimap.
    #
    # @param [Player] player the player of the game.
    def clear_and_minimap(player)
      system("clear") unless ENV["TEST"]
      describe_tile(player)
    end

    # Runs a single command from the player on the world map.
    #
    # @param [Player] player the player of the game.
    # @return [Bool] true iff the player does not want to quit.
    def run_turn(player)

      # Play music and re-display the minimap (when appropriate).
      music = player.location.map.music
      play_music(music) if music
      if player.moved
        clear_and_minimap(player)
        player.moved = false
      end

      # Receive input and run the command.
      input = player_input prompt: '> '
      interpret_command(input, player)

      return !input.eql?("quit")
    end

end
