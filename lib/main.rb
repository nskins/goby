require_relative "driver.rb"
require_relative "Entity/player.rb"

system("clear")

player = Player.new(
                   )
run_driver(player)
