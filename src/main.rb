require_relative "driver.rb"
require_relative "Entity/player.rb"
require_relative "Map/Map/donut_field.rb"

player = Player.new(name: "Player1",
                    map: DonutField.new,
                    location: Couple.new(1,1))
run_driver(player)
