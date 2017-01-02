require_relative 'event.rb'
require_relative '../Item/cookable.rb'

class Stove < Event
  def initialize
    super(command: "cook")
  end
  
  def run(player)
    puts "You can cook either a single item or a recipe."
    print "What would you like to cook?: "
    
    input = gets.chomp
    index = player.has_item(input)
    # TODO: must check recipe book first since
    #       might have that item in inventory.
    
    print "\n"
    if !index
      print "What?! You don't have THAT!\n\n"
    elsif (defined?(player.inventory[index].first.cooked).nil?)
      print "You can't cook #{player.inventory[index].first.name}!\n\n"
    else
      print "How many?: "
      input = gets.chomp
      amount = input.to_i
      if (amount > player.inventory[index].second)
        print "\nYou don't have that many!\n\n"
      elsif (amount <= 0)
        print "\nYou must choose a positive amount!\n\n"
      else
        success = 0
        failure = 0
        amount.times do
          random = [true, false].sample
          (success = success + 1) if random
          (failure = failure + 1) unless random
        end
        puts "\nResults:"
        puts "* #{player.inventory[index].first.cooked.name} (#{success})"
        print "* Burnt Flub (#{failure})\n\n"
        player.add_item(player.inventory[index].first.cooked, success) if (success > 0)
        player.add_item(BurntFlub.new, failure) if (failure > 0)
        player.remove_item(player.inventory[index].first, amount)
      end
    end
  end
end