require_relative 'npc.rb'
require_relative '../../Item/bucket.rb'

class Tim < NPC
  def initialize
    super(name: "Tim")
  end
  
  def run(player)
    case @mode
    when 0
      type("#{@name}: Ah, hello #{player.name}! It seems a bit\n")
      type("chilly out today, huh? I found this\n")
      type("strange device, but I don't need it.\n")
      type("Maybe you could use it?\n\n")
      type("Obtained Bucket!\n\n")
      player.add_item(Bucket.new)
      @mode = 1
    when 1
      type("#{@name}: Did you find out how to use that\n")
      type("strange device? It seems intriguing...\n\n")
    end
  end
end