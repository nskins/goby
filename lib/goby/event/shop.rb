require 'goby'

module Goby

  # Allows a player to buy and sell Items.
  class Shop < Event

    # Message for when the shop has nothing to sell.
    NO_ITEMS_MESSAGE = "Sorry, we're out of stock right now!\n\n"
    # Message for when the player has nothing to sell.
    NOTHING_TO_SELL = "You have nothing to sell!\n\n"
    # Introductory greeting at the shop.
    WARES_MESSAGE = "Please take a look at my wares.\n\n"

    # @param [String] name the name.
    # @param [Integer] mode convenient way for a shop to have multiple actions.
    # @param [Boolean] visible whether the shop can be seen/activated.
    # @param [[Item]] items an array of items that the shop sells.
    def initialize(name: "Shop", mode: 0, visible: true, items: [])
      super(mode: mode, visible: visible)
      @name = name
      @command = "shop"
      @items = items
    end

    # The chain of events for buying an item (w/ error checking).
    #
    # @param [Player] player the player trying to buy an item.
    def buy(player)

      print_items
      return if @items.empty?

      print "What would you like (or none)?: "
      name = player_input
      index = has_item(name)

      # The player does not want to buy an item.
      return if name.casecmp("none").zero?

      if index.nil? # non-existent item.
        print "I don't have #{name}!\n\n"
        return
      end

      # The specified item exists in the shop's inventory.
      item = @items[index]
      print "How many do you want?: "
      amount_to_buy = player_input
      total_cost = amount_to_buy.to_i * item.price

      if total_cost > player.gold # not enough gold.
        puts "You don't have enough gold!"
        print "You only have #{player.gold}, but you need #{total_cost}!\n\n"
        return
      elsif amount_to_buy.to_i < 1 # non-positive amount.
        puts "Is this some kind of joke?"
        print "You need to request a positive amount!\n\n"
        return
      end

      # The player specifies a positive amount.
      player.remove_gold(total_cost)
      player.add_item(item, amount_to_buy.to_i)
      print "Thank you for your patronage!\n\n"

    end

    # Returns the index of the specified item, if it exists.
    #
    # @param [String] name the item's name.
    # @return [Integer] the index of an existing item. Otherwise nil.
    def has_item(name)
      @items.each_with_index do |item, index|
        return index if item.name.casecmp(name).zero?
      end
      return
    end

    # Displays the player's current amount of gold
    # and a greeting. Inquires about next action.
    #
    # @param [Player] player the player interacting with the shop.
    # @return [String] the player's input.
    def print_gold_and_greeting(player)
      puts "Current gold in your pouch: #{player.gold}."
      print "Would you like to buy, sell, or exit?: "
      input = player_input doublespace: false
      print "\n"
      return input
    end

    # Displays a formatted list of the Shop's items
    # or a message signaling there is nothing to sell.
    def print_items
      if @items.empty?
        print NO_ITEMS_MESSAGE
      else
        print WARES_MESSAGE
        @items.each { |item| puts "#{item.name} (#{item.price} gold)" }
        print "\n"
      end
    end

    # The amount for which the shop will purchase the item.
    #
    # @param [Item] item the item in question.
    # @return [Integer] the amount for which to purchase.
    def purchase_price(item)
      item.price / 2
    end

    # The default shop experience.
    #
    # @param [Player] player the player interacting with the shop.
    def run(player)

      # Initial greeting.
      puts "Welcome to #{@name}."
      input = print_gold_and_greeting(player)

      while input.casecmp("exit").nonzero?
        if input.casecmp("buy").zero?
          buy(player)
        elsif input.casecmp("sell").zero?
          sell(player)
        end
        input = print_gold_and_greeting(player)
      end

      print "#{player.name} has left #{@name}.\n\n"
    end

    # The chain of events for selling an item (w/ error checking).
    #
    # @param [Player] player the player trying to sell an item.
    def sell(player)

      # The player has nothing to sell.
      if player.inventory.empty?
        print NOTHING_TO_SELL
        return
      end

      player.print_inventory

      print 'What would you like to sell? (or none): '
      input = player_input
      inventory_entry = player.inventory_entry(input)

      # The player does not want to sell an item.
      return if input.casecmp?('none')

      unless inventory_entry # non-existent item.
        print "You can't sell what you don't have.\n\n"
        return
      end

      item = inventory_entry.first
      item_count = inventory_entry.second

      unless item.disposable # non-disposable item (cannot sell/drop).
        print "You cannot sell that item.\n\n"
        return
      end

      puts "I'll buy that for #{purchase_price(item)} gold."
      print 'How many do you want to sell?: '
      amount_to_sell = player_input.to_i

      if amount_to_sell > item_count # more than in the inventory.
        print "You don't have that many to sell!\n\n"
        return
      elsif amount_to_sell < 1 # non-positive amount specified.
        puts 'Is this some kind of joke?'
        print "You need to sell a positive amount!\n\n"
        return
      end

      player.add_gold(purchase_price(item) * amount_to_sell)
      player.remove_item(item, amount_to_sell)
      print "Thank you for your patronage!\n\n"

    end

    attr_accessor :name, :items

  end

end