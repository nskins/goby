require_relative 'tile.rb'

class Stone < Tile
  def initialize
    super(description: "You are standing on stone ground.", graphic: '□')
  end
end