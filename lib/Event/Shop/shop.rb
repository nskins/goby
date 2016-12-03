require_relative '../event.rb'

class Shop < Event

  # @param [Hash] params the parameters for creating a Shop.
  # @option params [String] :name the name.
  # @option params [Integer] :mode convenient way for a shop to have multiple actions.
  # @option params [Boolean] :visible whether the shop can be seen/activated.
  # @option params [[Item]] :items an array of items that the shop sells.
  def initialize(params = {})
    super(params)
    @name = params[:name] || "Shop"
    @command = "shop"
    @items = params[:items] || Array.new
  end

  # Returns the index of the specified item, if it exists.
  #
  # @param [String] name the item's name.
  # @return [Integer] the index of an existing item. Otherwise -1.
  def has_item(name)
    @items.each_with_index do |item, index|
      if (item.name.casecmp(name) == 0)
        return index
      end
    end
    return -1
  end

  # Displays a formatted list of the Shop's items.
  def print_items
    @items.each do |item|
      puts item.name + " (#{item.price} gold)"
    end
    print "\n"
  end

  # The default shop experience.
  #
  # @param [Player] player the player interacting with the shop.
  def run(player)

    # Initial greeting.
    puts "Welcome to #{@name}."
    puts "Current gold in your pouch: #{player.gold}."
    print "Would you like to buy, sell, or exit?: "

    input = gets.chomp
    print "\n"

    while (input.casecmp("exit") != 0)

      if (input.casecmp("buy") == 0)
        print "Please take a look at my wares.\n\n"
        print_items
        print "What would you like (or none)?: "

        name = gets.chomp
        index = has_item(name)

        # Case: The player does not want to buy an item.
        if (name.casecmp("none") == 0)

        # Case: The specified item exists in the shop's inventory.
        elsif (index != -1)
          item = @items[index]
          print "How many do you want?: "
          amount_to_buy = gets.chomp
          total_cost = amount_to_buy.to_i * item.price

          # Case: The player does not have enough gold.
          if (total_cost > player.gold)
            puts "\nYou don't have enough gold!"
            print "You only have #{player.gold}, but you need #{total_cost}!\n\n"

          # Case: The player has enough gold.
          else

            # Case: The player specifies a non-positive amount.
            if (amount_to_buy.to_i < 1)
              puts "\nIs this some kind of joke?"
              print "You need to request a positive amount!\n\n"

            # Case: The player specifies a positive amount.
            else
              player.gold -= total_cost
              player.add_item(item, amount_to_buy.to_i)
              print "\nThank you for your patronage!\n\n"
            end
          end

        # Case: The specified item does not exist in the shop's inventory.
        else
          print "\nI don't have #{name}!\n\n"
        end

      elsif (input.casecmp("sell") == 0)

        # Case: The player has at least one item in its inventory.
        if (!player.inventory.empty?)
          puts "Your inventory:"
          player.print_inventory

          print "What would you like to sell? (or none): "
          name = gets.chomp
          index = player.has_item(name)

          # Case: The player does not want to sell an item.
          if (name.casecmp("none") == 0)

          # Case: The player has a positive number of the specified item.
          elsif ((index > -1) && (item_count = player.inventory[index].second) > 0)
            item = player.inventory[index].first
            puts "\nI'll buy that for #{item.price / 2} gold."
            print "How many do you want to sell?: "
            amount_to_sell = gets.chomp

            # Case: The player specifies more than the amount in its inventory.
            if (amount_to_sell.to_i > item_count)
              print "\nYou don't have that many to sell!\n\n"

            # Case: The player specifies a valid number of items to sell.
            else

              # Case: The player specifies a non-positive amount to sell.
              if (amount_to_sell.to_i < 1)
                puts "\nIs this some kind of joke?"
                print "You need to sell a positive amount!\n\n"

              # Case: The player specifies a positive amount to sell.
              else
                player.gold += (item.price / 2) * amount_to_sell.to_i
                player.remove_item(item, amount_to_sell.to_i)
                print "\nThank you for your patronage!\n\n"
              end
            end

          # Case: The player does not specify an existing item in the inventory.
          else
            print "\nYou can't sell what you don't have.\n\n"
          end

        # Case: The player does not have anything to sell.
        else
          print "You have nothing to sell!!\n\n"
        end
      end

      # Greeting for subsequent interactions (following the initial).
      puts "Current gold in your pouch: #{player.gold}."
      print "Would you like to buy, sell, or exit?: "
      input = gets.chomp
      print "\n"
    end
    print "#{player.name} has left #{@name}.\n\n"
  end

  attr_accessor :name, :items

end
