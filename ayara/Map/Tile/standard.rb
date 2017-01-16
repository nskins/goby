require_relative '../../../lib/Map/Tile/tile.rb'

class Grass < Tile
  def initialize
    super(description: "You are standing on some grass.")
  end
end

class Stone < Tile
  def initialize
    super(description: "You are standing on stone ground.", graphic: '□')
  end
end

class Wall < Tile
  def initialize
    super(passable: false)
  end
end

class Water < Tile
  def initialize
    super(passable: false, graphic: '♒')
  end
end