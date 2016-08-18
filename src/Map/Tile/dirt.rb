require_relative 'tile.rb'

class Dirt < Tile

  def initialize(params = {})
    super(params)
    @description = params[:description] || "Dirt surrounds you."
  end

end
