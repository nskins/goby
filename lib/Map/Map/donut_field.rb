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
    
    shop = Tile.new(graphic: "△")
    event = Dirt.new(graphic: "?")
    
    @tiles = Array.new
    
    # Create a 3x3 map of all one type of Tile (Dirt),
    3.times do |i|
      @tiles[i] = Array.new
      2.times do |j|
        @tiles[i][j] = dirt.clone
      end
    end 
    
    # Put the wall in the center.
    @tiles[1][1] = wall.clone
    
    # Add special events to the first row.
    @tiles[0][2] = event.clone
    @tiles[0][2].description = "Dirt surrounds you.\nYou sense a strange presence."
    @tiles[0][2].monsters = [Alien.new]
    
    # Add special events to the second row.
    @tiles[1][2] = event.clone
    @tiles[1][2].events = [Dan.new]
      
    # Add special events to the third row.
    @tiles[2][0] = shop.clone
    @tiles[2][0].description = "The world-famous \"Bob's Bakery\" stands here."
    @tiles[2][0].events = [Bakery.new, Hole.new]
    
    @tiles[2][1] = event.clone
    @tiles[2][1].events = [Box.new(gold: 60)]
    
    @tiles[2][2] = shop.clone
    @tiles[2][2].description = "There is a shop with strange clothes nearby."
    @tiles[2][2].events = [WackyClothesShop.new]

    # Set the location for the character to spawn after death.
    @regen_location = Couple.new(0,0)
  end
end
