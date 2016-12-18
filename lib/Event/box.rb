require_relative 'event.rb'

# PRESET DATA
class Box < Event

  def initialize(gold: 0)
    super(command: "open")
    @gold = gold
  end

  def run(player)
    puts "You rip open the box..."
    print "...and find #{@gold} gold inside!\n\n"
    player.gold += @gold
    
    @visible = false
    player.map.tiles[player.location.first][player.location.second].graphic = Tile::DEFAULT_PASSABLE
  end

  attr_accessor :gold
end
