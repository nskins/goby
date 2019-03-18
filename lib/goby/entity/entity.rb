require 'goby'

module Goby
  # Provides the ability to fight, equip/unequip weapons & armor,
  # and carry items & gold.
  class Entity
    # Error when the entity specifies a non-existent item.
    NO_SUCH_ITEM_ERROR = "What?! You don't have THAT!\n\n".freeze
    # Error when the entity specifies an item not equipped.
    NOT_EQUIPPED_ERROR = "You are not equipping THAT!\n\n".freeze

    # @param [String] name the name.
    # @param [Hash] stats hash of stats
    # @option stats [Integer] :max_hp maximum health points. Set to be positive.
    # @option stats [Integer] :hp current health points. Set to be nonnegative.
    # @option stats [Integer] :attack strength in battle. Set to be positive.
    # @option stats [Integer] :defense protection from attacks. Set to be positive.
    # @option stats [Integer] :agility speed of commands in battle. Set to be positive.
    # @param [[C(Item, Integer)]] inventory a list of pairs of items and their respective amounts.
    # @param [Integer] gold the currency used for economical transactions.
    # @param [Hash] outfit the collection of equippable items currently worn.
    def initialize(name: 'Entity', stats: {}, inventory: [], gold: 0, outfit: {})
      @name = name
      set_stats(stats)
      @inventory = inventory
      set_gold(gold)

      # See its attr_accessor below.
      @outfit = {}
      outfit.each do |_type, value|
        value.equip(self)
      end

      # This should only be switched to true during battle.
      @escaped = false
    end

    # Adjusts gold by the given amount.
    # Entity's gold will not be less than zero.
    #
    # @param [Integer] amount the amount of gold to adjust by.
    def adjust_gold_by(amount)
      set_gold(@gold + amount)
    end

    # Adds the item and the given amount to the inventory.
    #
    # @param [Item] item the item being added.
    # @param [Integer] amount the amount of the item to add.
    def add_item(item, amount = 1)
      found = @inventory.detect { |couple| couple.first == item }
      if found
        found.second += amount
      else
        @inventory.push(C[item, amount])
      end
    end

    # Adds the specified gold and treasures to the inventory.
    #
    # @param [Integer] gold the amount of gold.
    # @param [[Item]] treasures the list of treasures.
    def add_loot(gold, treasures)
      (treasures ||= []).compact!
      type('Loot: ')
      if gold.positive? || treasures.any?
        print "\n"
        if gold.positive?
          type("* #{gold} gold\n")
          adjust_gold_by(gold)
        end
        treasures.each do |treasure|
          type("* #{treasure.name}\n")
          add_item(treasure)
        end
        print "\n"
      else
        type("nothing!\n\n")
      end
    end

    # Removes all items from the entity's inventory.
    def clear_inventory
      @inventory = []
    end

    def drop_item(name)
      item = inventory_entry(name)&.first
      if item
        if item.disposable
          # TODO: Perhaps the player should be allowed to specify
          #       how many of the Item to drop.
          remove_item(item, 1)
          print "You have dropped #{item}.\n\n"
        else
          print "You cannot drop that item.\n\n"
        end
      else
        print NO_ITEM_DROP_ERROR
      end
    end

    # Equips the specified item to the entity's outfit.
    #
    # @param [Item, String] item the item (or its name) to equip.
    def equip_item(item)
      actual_item = inventory_entry(item)&.first
      if actual_item
        # Checks for Equippable without importing the file.
        if defined? actual_item.equip
          actual_item.equip(self)

          # Equipping the item will always remove it from the entity's inventory.
          remove_item(actual_item)
        else
          print "#{actual_item.name} cannot be equipped!\n\n"
        end
      else
        print NO_SUCH_ITEM_ERROR
      end
    end

    # Returns the index of the specified item, if it exists.
    #
    # @param [Item, String] item the item (or its name).
    # @return [Integer] the index of an existing item. Otherwise nil.
    def inventory_entry(item)
      inventory.detect { |couple| couple.first.name.casecmp?(item.to_s) }
    end

    # Prints the inventory in a nice format.
    def print_inventory
      print "Current gold in pouch: #{@gold}.\n\n"

      if @inventory.empty?
        print "#{@name}'s inventory is empty!\n\n"
        return
      end

      puts "#{@name}'s inventory:"
      @inventory.each do |couple|
        puts "* #{couple.first.name} (#{couple.second})"
      end
      print "\n"
    end

    # Prints the status in a nice format.
    def print_status
      puts 'Stats:'
      puts "* HP: #{@stats[:hp]}/#{@stats[:max_hp]}"
      %i[attack defense agility].each do |stat|
        puts "* #{stat.to_s.capitalize}: #{@stats[stat]}"
      end
      print "\n"

      puts 'Equipment:'
      %i[weapon shield helmet torso legs].each do |equipment|
        print "* #{equipment.to_s.capitalize}: "
        puts @outfit[equipment] ? @outfit[equipment].name.to_s : 'none'
      end
      print "\n"
    end

    # Removes the item, if it exists, and, at most, the given amount from the inventory.
    #
    # @param [Item] item the item being removed.
    # @param [Integer] amount the amount of the item to remove.
    def remove_item(item, amount = 1)
      couple = inventory_entry(item)
      if couple
        couple.second -= amount
        @inventory.delete(couple) if couple.second.nonpositive?
      end
    end

    # Sets the Entity's gold to the number in the argument.
    # Only nonnegative numbers are accepted.
    #
    # @param [Integer] gold the amount of gold to set.
    def set_gold(gold)
      @gold = [gold, 0].max
    end

    # Sets stats
    #
    # @param [Hash] passed_in_stats value pairs of stats
    # @option passed_in_stats [Integer] :max_hp maximum health points. Set to be positive.
    # @option passed_in_stats [Integer] :hp current health points. Set to be nonnegative.
    # @option passed_in_stats [Integer] :attack strength in battle. Set to be positive.
    # @option passed_in_stats [Integer] :defense protection from attacks. Set to be positive.
    # @option passed_in_stats [Integer] :agility speed of commands in battle. Set to be positive.
    def set_stats(passed_in_stats)
      @stats ||= { max_hp: 1, hp: nil, attack: 1, defense: 1, agility: 1 }
      stats = @stats.merge(passed_in_stats)

      # Set hp to max_hp if hp not specified
      stats[:hp] ||= stats[:max_hp]
      # hp should not be greater than max_hp and be at least 0
      stats[:hp] = [[stats[:hp], stats[:max_hp]].min, 0].max
      # ensure all other stats > 0
      stats.each do |key, value|
        if %i[max_hp attack defense agility].include?(key)
          stats[key] = [value, 1].max
        end
      end

      @stats = stats
    end

    # getter for stats
    #
    # @return [Object]
    def stats
      # attr_reader makes sure stats cannot be set via stats=
      # freeze makes sure that stats []= cannot be used
      @stats.freeze
    end

    # Unequips the specified item from the entity's outfit.
    #
    # @param [Item, String] item the item (or its name) to unequip.
    def unequip_item(item)
      pair = @outfit.detect { |_type, value| value.name.casecmp?(item.to_s) }
      if pair
        # On a successful find, the "detect" method always returns
        # an array of length 2; thus, the following line should not fail.
        item = pair[1]
        item.unequip(self)
        add_item(item)
      else
        print NOT_EQUIPPED_ERROR
      end
    end

    # Uses the item, if it exists, on the specified entity.
    #
    # @param [Item, String] item the item (or its name) to use.
    # @param [Entity] entity the entity on which to use the item.
    def use_item(item, entity)
      actual_item = inventory_entry(item)&.first
      if actual_item
        actual_item.use(self, entity)
        remove_item(actual_item) if actual_item.consumable
      else
        print NO_SUCH_ITEM_ERROR
      end
    end

    # @param [Entity] rhs the entity on the right.
    def ==(rhs)
      @name == rhs.name
    end

    def dead?
      @stats[:hp] <= 0
    end

    attr_accessor :escaped, :inventory, :name
    attr_reader :gold, :outfit
  end
end
