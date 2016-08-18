require_relative 'tile.rb'

class Wall < Tile
  def initialize(params = {})
    super(params)
    @passable = false
  end
end
