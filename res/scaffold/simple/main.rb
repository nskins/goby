require 'goby'

include Goby

require_relative 'map/farm.rb'

# Set this to true in order to use BGM.
Music::set_playback(false)

# By default, we've included no music files.
# The Music module also includes a function
# to change the music-playing program.

# Clear the terminal.
system("clear")

# Allow the player to load an existing game.
if File.exists?("player.yaml")
  print "Load the saved file?: "
  input = player_input
  if input.is_positive?
    player = load_game("player.yaml")
  end
end

# No load? Create a new player.
if player.nil?
  # A Location specifies the Map and (y,x) coordinates of a Player.
  home = Location.new(Farm.new, C[1, 1])

  # Use the Player constructor to set the
  # location, stats, gold, inventory, and more.
  player = Player.new(location: home)

end

run_driver(player)
