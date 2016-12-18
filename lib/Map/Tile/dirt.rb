require_relative 'tile.rb'

# PRESET DATA
class Dirt < Tile
  def initialize
    super(description: "Dirt surrounds you.")
  end
end
