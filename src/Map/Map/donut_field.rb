require_relative 'map.rb'
require_relative '../Tile/dirt.rb'
require_relative '../Tile/wall.rb'
require_relative '../../Entity/Monster/alien.rb'
require_relative '../../Event/box.rb'
require_relative '../../Event/Shop/bakery.rb'

class DonutField < Map

  def initialize(params = {})
    @name = "Donut Field"
    @tiles = [
              [ Wall.new, Wall.new, Wall.new, Wall.new, Wall.new ],

              [ Wall.new, Dirt.new, Dirt.new,
                  Dirt.new(description: "Dirt surrounds you.\nYou sense a strange presence.",
                           monsters: [Alien.new]),
                  Wall.new ],

              [ Wall.new, Dirt.new, Wall.new, Dirt.new, Wall.new ],

              [ Wall.new, Dirt.new(description: "The world-famous \"Bob's Bakery\" stands here.",
                                   events: [Bakery.new]),
                  Dirt.new(description: "A small box is submerged in the mud.",
                           events: [ Box.new(gold: 60) ] ),
                  Dirt.new, Wall.new ],

              [ Wall.new, Wall.new, Wall.new, Wall.new, Wall.new ]
             ]
    @regen_location = Couple.new(1,1)
  end

end
