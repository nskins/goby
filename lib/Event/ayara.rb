require_relative 'house.rb'
require_relative '../Item/bucket.rb'

class TimHouse < House
  def initialize
    super(name: "Tim's wife")
  end
  
  def run(player)
    super(player)
    
    if (player.has_item(Bucket.new) != -1)
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