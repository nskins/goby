require_relative 'npc.rb'
require_relative '../../Item/basketball.rb'
require_relative '../../Item/bucket.rb'

class Andre < NPC
  def initialize
    super(name: "Andre")
  end
  
  def run(player)
    if player.has_item(Basketball.new).nil?
      type("#{@name}: Huh? Come back when you have\n")
      type("a Basketball, dear child.\n\n")
      return
    end
    
    type("#{@name}: Each player takes five shots -\n")
    type("whoever makes more wins. Would you like\n")
    type("to make a wager (y/n)?: ")
    input = gets.chomp
    print "\n"
    return if input != 'y'
    
    puts "Current gold in pouch: #{player.gold}."
    type("#{@name}: How much will you wager?: ")
    input = gets.chomp
    amount = input.to_i
    print "\n"
    
    if (amount < 1)
      type("#{@name}: You need to choose a positive amount!\n\n")
      return
    elsif (amount > player.gold)
      type("#{@name}: You can't wager more than you have!\n\n")
      return
    end
    
    type("#{@name}: Good. Let's go!\n\n")
    
    # Player shoots.
    shots_made = 0
    5.times do
      success = shoot
      shots_made += 1 if success
      print "\n"
    end
    
    # Choose a random number of shots that Andre made.
    random = Random.rand(6)
    
    puts "Andre's score: #{random}."
    print "Your score: #{shots_made}.\n\n"
    
    # Final output and movement of gold.
    if (random < shots_made)
      print "You win #{amount} gold!\n\n"
      player.gold += amount
    elsif (random > shots_made)
      print "You lose #{amount} gold...\n\n"
      player.gold -= amount
    else
      print "It's a tie!\n\n"
    end
      
  end
  
  include(BBall)
end

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

class John < NPC
  def initialize
    super(name: "John")
    @pairs = [Couple.new(BoiledEgg.new, 8), 
              Couple.new(Bluegill.new, 6), 
              Couple.new(ScrambledEggs.new, 50)]
    @current_index = nil
  end
  
  def run(player)
    case @mode
    when 0
      # Choose a random pair.
      @current_index = Random.rand(@pairs.size)
    
      type("#{@name}: Hello. Could you please bring me\n")
      type("#{@pairs[@current_index].first.name}? I am very hungry.\n")
      type("Don't worry.. I will pay you for your services.\n\n")
      @mode = 1
    when 1
      if (player.has_item(@pairs[@current_index].first))
        type("#{@name}: Ah, yes! #{@pairs[@current_index].first.name}!\n")
        type("May I have it (y/n)?: ")
        input = gets.chomp
        print "\n"
        
        if (input == 'y')
          type("#{@name}: Thank you! Thank you! Here, have this.\n\n")
          print "Obtained #{@pairs[@current_index].second} gold!\n\n"
          player.gold += @pairs[@current_index].second
          player.remove_item(@pairs[@current_index].first)
          @mode = 0
        else
          type("#{@name}: How rude!\n\n")
        end
      else
        type("#{@name}: I'd like #{@pairs[@current_index].first.name}, please!\n\n")
      end
    end
  end
  
  # Array<Couple(Food, Integer)>
  # Type of Food the NPC wants and the reward given.
  attr_accessor :pairs
  # Integer
  # The index of pairs that the NPC currently wants.
  attr_accessor :current_index
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