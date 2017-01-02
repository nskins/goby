require_relative 'event.rb'
require_relative '../Item/bait.rb'
require_relative '../Item/fishing_pole.rb'

class Pool < Event
  def initialize(mode: 0, visible: true, fish: Baitable.new)
    super(mode: mode, visible: visible)
    @command = "fish"
    @fish = fish
  end
  
  def run(player)
    if player.has_item(FishingPole.new).nil?
      print "In order to fish, you need a Fishing Pole.\n\n"
    else
      baits = find_baits(player)
      if (baits.empty?)
        print "In order to fish, you need some sort of bait.\n\n"
      else
        puts "Baits:"
        baits.each do |bait|
          puts "* #{bait.name}"
        end
        print "\nWhich bait will you use?: "
        input = gets.chomp
        index = player.has_item(input)
        if (index || (!(player.inventory[index].first.is_a? Bait)))
          print "What?! You don't have THAT!\n\n"
        else
          bait = player.inventory[index].first
          puts "\nYou cast the fishing line..."
          player.remove_item(bait)
          sleep(2)
          if ((@fish.bait == bait) && [true, false].sample)
            print "Wow! You caught #{@fish.name}!\n\n"
            player.add_item(@fish)
          else
            print "Nothing takes the bait!\n\n"
          end
        end
      end
    end
  end
  
  attr_accessor :fish
  
  private
    
    def find_baits(player)
      baits = []
      player.inventory.each do |item|
        if (item.first.is_a? Bait)
          baits << item.first
        end
      end
      return baits
    end
    
end

# Subclasses
class BluegillPool < Pool
  def initialize
    super(fish: RawBluegill.new)
  end
end