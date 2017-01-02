require_relative 'npc.rb'
require_relative '../../Item/basketball.rb'
require_relative '../../Item/bucket.rb'

class Antonio < NPC
  def initialize
    super(name: "Antonio")
  end
  
  def run(player)
    type("#{@name}: Yes, I've been fishing for many\n")
    type("years. Stand aside. You're ruining the\n")
    type("balance of my inner life force.\n\n")
  end
end

class Bella < NPC
  def initialize
    super(name: "Bella")
  end
  
  def run(player)
    if player.has_item(BucketOfWater.new).nil?
      type("#{@name}: Oooh.. hello? Please... bring me\n")
      type("water... I'm dehydrated... ooooohhhhhh.....\n\n")
    else
      type("#{@name}: Oooh.. you have water... ??\n")
      type("May I please have it... (y/n)?: ")
      input = gets.chomp
      print "\n"
      
      if (input == 'y')
        type("#{@name}: Quickly, hand it to me....\n\n")
        sleep(2)
        type("*glurp glurp glurp*\n\n")
        sleep(2)
        type("#{@name}: Oh, thank you so much. I feel\n")
        type("much better. I'm done with exercise\n")
        type("for now. You can have my basketball.\n\n")
        type("Obtained Basketball!\n\n")
        
        # Modify items in the player's inventory.
        player.remove_item(BucketOfWater.new)
        player.add_item(Bucket.new)
        player.add_item(Basketball.new)
        
        # Remove the event from the map.
        @visible = false
        y = player.location.first
        x = player.location.second
        player.map.tiles[y][x].description = "You are standing on some grass."
      else
        type("#{@name}: Oooh..\n")
        type("*She rolls over in extreme pain*\n\n")
      end  
    end
  end
end

class Helen < NPC
  def initialize
    super(name: "Helen")
  end
  
  def run(player)
    type("#{@name}: Each type of fish prefers a particular\n")
    type("type of bait. If one bait doesn't seem to work,\n")
    type("then try another. You could also just be unlucky...\n\n")
  end
end

class Tim < NPC
  def initialize
    super(name: "Tim")
  end
  
  def run(player)
    if player.has_item(Bucket.new).nil?
      type("#{@name}: Ah, hello #{player.name}! It seems a bit\n")
      type("chilly out today, huh? I found this\n")
      type("strange device, but I don't need it.\n")
      type("Maybe you could use it?\n\n")
      type("Obtained Bucket!\n\n")
      player.add_item(Bucket.new)
    else
      type("#{@name}: Did you find out how to use that\n")
      type("strange device? It seems intriguing...\n\n")
    end
  end
end