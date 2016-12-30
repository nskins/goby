require_relative 'map.rb'
require_relative '../Tile/grass.rb'
require_relative '../Tile/stone.rb'
require_relative '../Tile/wall.rb'
require_relative '../../Event/ayara.rb'
require_relative '../../Event/rest.rb'
require_relative '../../Event/NPC/ayara.rb'
require_relative '../../Event/Shop/ayara.rb'

class Ayara < Map
  def initialize
    super(name: "Ayara", regen_location: Couple.new(11,4))
    
    grass = Grass.new
    stone = Stone.new
    wall = Wall.new
    shop = Tile.new(graphic: '△')
    
    @tiles = []
    
    13.times do |y|
      @tiles[y] = []
      13.times do |x|
        @tiles[y][x] = grass.clone
      end
    end
    
    # Construct the north and south walls of the city.
    7.times do |x|
      @tiles[0][x+3] = wall.clone
      @tiles[12][x+3] = wall.clone
    end
    
    # Construct the east wall of the city.
    5.times do |y|
      @tiles[y+4][0] = wall.clone
    end
    
    # Construct a couple walls on the west of the city.
    @tiles[4][12] = wall.clone
    @tiles[8][12] = wall.clone
    
    # Construct the corner walls of the city.
    # TODO: some mathematical relationship could
    #       probably make this shorter.
    2.times do |x|
      @tiles[1][x+2] = wall.clone
      @tiles[2][x+1] = wall.clone
      @tiles[3][x] = wall.clone
      
      @tiles[1][x+9] = wall.clone
      @tiles[2][x+10] = wall.clone
      @tiles[3][x+11] = wall.clone
      
      @tiles[9][x] = wall.clone
      @tiles[10][x+1] = wall.clone
      @tiles[11][x+2] = wall.clone
      
      @tiles[9][x+11] = wall.clone
      @tiles[10][x+10] = wall.clone
      @tiles[11][x+9] = wall.clone
    end
    
    # Mayor's house.
    @tiles[1][6].description = "This is the mayor's house. There's\n"\
                               "a big sign on the front door that\n"\
                               "reads: 'NO SOLICITING.'"
    @tiles[1][6].events = [MayorHouse.new]
    @tiles[1][6].graphic = 'Ω'
    
    # Northward path from the city square.
    3.times do |y|
      @tiles[y+2][6] = stone.clone
    end
    
    # Stone pathway which marks the city square.
    3.times do |y|
      3.times do |x|
        @tiles[y+5][x+5] = stone.clone
      end
    end
    
    # Farmer's market - near the city square.
    3.times do |y|
      @tiles[y+5][8] = shop.clone
      @tiles[y+5][8].description = "This is the farmer's market."
    end
    
    @tiles[5][8].events = [FarmersMarket1.new]
    @tiles[6][8].events = [FarmersMarket2.new]
    @tiles[7][8].events = [FarmersMarket3.new]
    
    # Southward path from the city square.
    2.times do |y|
      @tiles[y+8][6] = stone.clone
    end
    
    # Stone floor for the southern part of the city.
    2.times do |y|
      5.times do |x|
        @tiles[y+10][x+4] = stone.clone
      end
    end
    
    # Tim's house.
    @tiles[10][7].description = "This is Tim's house. There are some\n"\
                                "lights hanging around. One of the\n"\
                                "windows is completely smashed."
    @tiles[10][7].events = [TimHouse.new]
    @tiles[10][7].graphic = 'Д'
    
    # The player's home.
    @tiles[11][4].description = "This is your house. It's nice and\n"\
                                "warm. There's a comfy bed inside."
    @tiles[11][4].events = [Rest.new]
    @tiles[11][4].graphic = 'Д'
    
    # Simple NPC.
    @tiles[11][5].description = "Your friend Tim is sitting on a bench."
    @tiles[11][5].events = [Tim.new]
  end
end