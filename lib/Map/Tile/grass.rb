require_relative 'tile.rb'

class Grass < Tile
  def initialize
    super(description: "You are standing on some grass.")
  end
end