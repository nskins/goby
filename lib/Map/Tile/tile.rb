class Tile
  
  # Default graphic for passable tiles.
  DEFAULT_PASSABLE = "·"
  # Default graphic for impassable tiles.
  DEFAULT_IMPASSABLE = "■"
  
  # @param [Boolean] passable if true, the player can move here.
  # @param [Boolean] seen if true, it will be printed on the map.
  # @param [String] description a summary/message of the contents.
  # @param [[Event]] events the events found on this tile.
  # @param [[Monster]] monsters the monsters found on this tile.
  # @param [String] graphic the respresentation of this tile graphically.
  def initialize(passable: true, seen: false, description: "", events: [], monsters: [], graphic: nil)
    @passable = passable
    @seen = seen
    @description = description
    @events = events
    @monsters = monsters
    @graphic = graphic.nil? ? default_graphic : graphic
  end

  # Convenient conversion to String.
  #
  # @return [String] the string representation.
  def to_s
    return @seen ? @graphic + " " : "  "
  end

  # Create deep copy of Tile
  #
  # @return Tile a new Tile object 
  def clone
    # First serialize the object, and then deserialize that into a new ruby object
    serialized_tile = Marshal.dump(self)
    new_tile = Marshal.load(serialized_tile)
    return new_tile           
  end
  
  attr_accessor :passable, :seen, :description, :events, :monsters, :graphic
  
  private
  
    # Returns the default graphic by considering passable.
    def default_graphic
      return DEFAULT_PASSABLE if @passable
      return DEFAULT_IMPASSABLE
    end
    
end