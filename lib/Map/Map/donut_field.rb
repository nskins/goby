require_relative 'map.rb'
require_relative '../Tile/dirt.rb'
require_relative '../Tile/wall.rb'
require_relative '../../Entity/Monster/alien.rb'
require_relative '../../Event/box.rb'
require_relative '../../Event/Shop/bakery.rb'

# PRESET DATA
class DonutField < Map
  def initialize(params = {})
    @name = "Donut Field"

    @tiles = [
              [ Dirt.new, Dirt.new,
                  Dirt.new(description: "Dirt surrounds you.\nYou sense a strange presence.",
                           monsters: [Alien.new]) ],

              [ Dirt.new, Wall.new, Dirt.new ],

              [ Dirt.new(description: "The world-famous \"Bob's Bakery\" stands here.",
                                   events: [Bakery.new]),
                  Dirt.new(description: "A small box is submerged in the mud.",
                           events: [ Box.new(gold: 60) ] ),
                  Dirt.new ]
             ]

    @regen_location = Couple.new(0,0)
  end
end
