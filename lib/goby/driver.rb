require 'goby'

module Goby

  include Music
  include WorldCommand

  # Runs the main game loop.
  #
  # @param [Player] player the player of the game.
  def run_driver(player)

    play_music(player.map.music) if player.map.music
    input = player_input prompt: '> '

    while (input.casecmp("quit").nonzero?)
      interpret_command(input, player)
      play_music(player.map.music) if player.map.music
      input = player_input prompt: '> '
    end

    stop_music

  end

end
