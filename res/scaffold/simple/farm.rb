# This is an example of how to create a Map. You can
# define the name, where to respawn, and
class Farm < Map
  def initialize
    super(name: "Farm", regen_location: Couple.new(2,2))

    # Define the main tiles on this map.
    grass = Tile.new

    # Fill the map with grass.
    @tiles = Array.new(5) { Array.new(5) { grass.clone } }

  end
end