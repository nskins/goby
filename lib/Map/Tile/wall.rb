require_relative 'tile.rb'

class Wall < Tile
  def initialize
    super(passable: false)
  end
end