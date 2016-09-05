require_relative 'tile.rb'

# PRESET DATA
class Wall < Tile
  def initialize(params = {})
    super(params)
    @passable = false
  end
end
