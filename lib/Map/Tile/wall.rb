require_relative 'tile.rb'

# PRESET DATA
class Wall < Tile
  def initialize(params = {passable: false})
    super(params)
  end
end
