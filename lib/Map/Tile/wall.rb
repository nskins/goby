require_relative 'tile.rb'

# PRESET DATA
class Wall < Tile
  def initialize
    super(passable: false)
  end
end
