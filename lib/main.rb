require_relative "driver.rb"
require_relative "Entity/player.rb"
require_relative "Map/Map/ayara.rb"

system("clear")

player = Player.new(map: Ayara.new,
                    location: Couple.new(5,5))
run_driver(player)
