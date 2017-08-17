require 'goby'
require 'optparse'
include Goby

# Command-line arguments.
options = {}
OptionParser.new do |opts|
  # Specify whether or not to play background music.
  opts.on("-m", "--[no-]music", "Run music") do |v|
    options[:music] = v
    Music::set_playback(v)
  end
end.parse!

system("clear")

# Allow the player to load an existing game.
if File.exists?("player.yaml")
  print "Load the saved file?: "
  input = player_input
  if input.is_positive?
    player = load_game("player.yaml")
    describe_tile(player)
  end
end

# No load? Create a new player.
if player.nil?

  # Use the Player constructor to set the
  # initial Map, (y,x) location, stats,
  # gold, inventory, and more.
  player = Player.new(gold: 1)

end

run_driver(player)
