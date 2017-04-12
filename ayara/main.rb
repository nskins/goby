require_relative "../lib/driver.rb"
require_relative "../lib/Battle/BattleCommand/use.rb"
require_relative "Battle/BattleCommand/Attack/punch.rb"
require_relative "../lib/Entity/player.rb"
require_relative "Map/Map/ayara.rb"
require_relative "Story/intro.rb"

# TODO: Place Main in a module?
include Driver

# Load the game.
if File.file?("player.yaml") && load_game?
  player = load_game
  system("clear")
  describe_tile(player)
else
  print_intro
  system("clear")

  name = get_name
  system("clear")

  player = Player.new(name: name,
                      max_hp: 15,
                      attack: 3,
                      map: Ayara.new,
                      location: Couple.new(11,4),
                      battle_commands: [Punch.new, Use.new]
                      )
end

run_driver(player)
