require_relative 'house.rb'
require_relative '../Item/bucket.rb'

class MayorHouse < House
  def initialize
    super(name: "Mayor")
  end
  
  def run(player)
    super(player)
    
    type("#{@name}: What? Who are you?\n")
    type("SCRAM PUNK!\n\n")
    print "*SLAM!*\n\n"
  end
end

class TimHouse < House
  def initialize
    super(name: "Tim's wife")
  end
  
  def run(player)
    super(player)
    
    if player.has_item(Bucket.new)
      type("#{@name}: AHA!!! So yer the one who took mah\n")
      type("watering contraption!? I've every right to report\n")
      type("ye to the authorities! Gimme that!\n\n")
      
      type("The Bucket is snatched away!\n\n")
      player.remove_item(Bucket.new)
    else
      type("#{@name}: Ye happen to see that lousy\n")
      type("ol' Tim hanging around somewhere? I tell ye\n")
      type("that man has no sense of responsibility!\n\n")
    end
  end
end

class Well < Event
  def initialize
    super(command: "fill")
  end
  
  def run(player)
    if player.has_item(Bucket.new)
      print "Will you fill the Bucket (y/n)?: "
      input = gets.chomp
      print "\n"
      
      if (input == 'y')
        puts "You attach the Bucket to the rope and feed it"
        puts "into the well. You pull the Bucket back up and"
        print "find that it's now filled with water.\n\n"
        player.remove_item(Bucket.new)
        player.add_item(BucketOfWater.new)
      end
    else
      print "You need some type of container!\n\n"
    end
  end
end