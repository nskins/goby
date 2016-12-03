require_relative 'npc.rb'
require_relative '../../util.rb'
require_relative '../../Item/shovel.rb'

# PRESET DATA
class Dan < NPC
  def initialize(params = { name: "Dan" })
    super(params)
  end

  def run(player)
    case mode
    when 0
      type("#{@name}: \"You'll need this.\"\n\n")
      type("Obtained Shovel!\n\n")

      player.add_item(Shovel.new)
      @mode = 1
    when 1
      type("#{@name}: \"I must go now.\"\n\n")
      
      @visible = false
      player.map.tiles[player.location.first][player.location.second].graphic = Tile::DEFAULT_PASSABLE
    end
  end
end
