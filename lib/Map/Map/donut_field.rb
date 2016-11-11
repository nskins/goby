require_relative 'map.rb'
require_relative '../Tile/dirt.rb'
require_relative '../Tile/wall.rb'
require_relative '../../Entity/Monster/alien.rb'
require_relative '../../Event/box.rb'
require_relative '../../Event/hole.rb'
require_relative '../../Event/NPC/dan.rb'
require_relative '../../Event/Shop/bakery.rb'
require_relative '../../Event/Shop/wacky_clothes.rb'

# PRESET DATA
class DonutField < Map
  def initialize(params = {})
    @name = "Donut Field"
    
    dirt = Dirt.new
    wall = Wall.new
    
    @tiles = Array.new
  
    # Set the first row of the map with generic Dirt.
    @tiles[0] = Array.new
    3.times { @tiles[0] << dirt.clone }
    
    # Add special events to the first row.
    @tiles[0][2].description = "Dirt surrounds you.\nYou sense a strange presence."
    @tiles[0][2].monsters = [Alien.new]
    
    # Set the second row of the map.
    @tiles[1] = Array.new
    @tiles[1] << dirt.clone << wall.clone << dirt.clone
    
    # Add special events to the second row.
    @tiles[1][2].events = [Dan.new]
    
    # Set the third row of the map.
    @tiles[2] = Array.new
    3.times { @tiles[2] << dirt.clone }
      
    # Add special events to the third row.
    @tiles[2][0].description = "The world-famous \"Bob's Bakery\" stands here."
    @tiles[2][0].events = [Bakery.new, Hole.new]
    @tiles[2][1].events = [Box.new(gold: 60)]
    @tiles[2][2].description = "There is a shop with strange clothes nearby."
    @tiles[2][2].events = [WackyClothesShop.new]

    # Set the location for the character to spawn after death.
    @regen_location = Couple.new(0,0)
  end
end
