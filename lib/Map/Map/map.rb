# A 2D arrangement of Tiles. The Player can move around on it.
class Map
  
  # @param [String] name the name.
  # @param [[Tile]] tiles the content of the map.
  # @param [Couple(Integer, Integer)] regen_location respawn-on-death coordinates.
  def initialize(name: "Map", tiles: [[Tile.new]], regen_location: Couple.new(0,0))
    @name = name
    @tiles = tiles
    @regen_location = regen_location
  end

  # Returns true when @tiles[y][x] is an existing index of @tiles.
  # Otherwise, returns false.
  #
  # @param [Integer] y the y-coordinate.
  # @param [Integer] x the x-coordinate.
  # @return [Boolean] the existence of the tile.
  def in_bounds(y, x)
    return (y >= 0 && y < @tiles.length && x >= 0 && x < @tiles[y].length)
  end

  # Prints the map in a nice format.
  def to_s
    output = ""
    @tiles.each do |row|
      row.each do |tile|
        output += (tile.graphic + " ")
      end
      output += "\n"
    end
    return output
  end

  # @param [Map] rhs the Map on the right.
  def ==(rhs)
    return @name == rhs.name
  end
  
  attr_accessor :name, :tiles, :regen_location
  
end