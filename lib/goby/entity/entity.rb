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

    # Adds the given amount of gold.
    #
    # @param [Integer] gold the amount of gold to add.
    def add_gold(gold)
      @gold += gold
      check_and_set_gold
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
      treasures ||= []
      type('Loot: ')
      if gold.positive? || treasures.any?
        print "\n"
        if gold.positive?
          type("* #{gold} gold\n")
          add_gold(gold)
        end
        treasures.each do |treasure|
          unless treasure.nil?
            type("* #{treasure.name}\n")
            add_item(treasure)
          end
        end
        print "\n"
      else
        type("nothing!\n\n")
      end
    end

    # Removes all items from the entity's inventory.
    def clear_inventory
      @inventory.pop while @inventory.size.nonzero?
    end

    def drop_item(name)
      index = has_item(name)
      if index && !inventory[index].first.disposable
        print "You cannot drop that item.\n\n"
      elsif index
        # TODO: Perhaps the player should be allowed to specify
        #       how many of the Item to drop.
        item = inventory[index].first
        remove_item(item, 1)
        print "You have dropped #{item}.\n\n"
      else
        print NO_ITEM_DROP_ERROR
      end
    end

    # Equips the specified item to the entity's outfit.
    #
    # @param [Item, String] item the item (or its name) to equip.
    def equip_item(item)
      index = has_item(item)
      if index
        actual_item = inventory[index].first

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
    def has_item(item)
      inventory.each_with_index do |couple, index|
        return index if couple.first.name.casecmp?(item.to_s)
      end
      nil
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
    # TODO: encapsulate print_stats and print_equipment in own functions.
    def print_status
      puts 'Stats:'
      puts "* HP: #{@stats[:hp]}/#{@stats[:max_hp]}"
      puts "* Attack: #{@stats[:attack]}"
      puts "* Defense: #{@stats[:defense]}"
      puts "* Agility: #{@stats[:agility]}"
      print "\n"

      puts 'Equipment:'
      print '* Weapon: '
      puts @outfit[:weapon] ? @outfit[:weapon].name.to_s : 'none'

      print '* Shield: '
      puts @outfit[:shield] ? @outfit[:shield].name.to_s : 'none'

      print '* Helmet: '
      puts @outfit[:helmet] ? @outfit[:helmet].name.to_s : 'none'

      print '* Torso: '
      puts @outfit[:torso] ? @outfit[:torso].name.to_s : 'none'

      print '* Legs: '
      puts @outfit[:legs] ? @outfit[:legs].name.to_s : 'none'

      print "\n"
    end

    # Removes up to the amount of gold given in the argument.
    # Entity's gold will not be less than zero.
    #
    # @param [Integer] gold the amount of gold to remove.
    def remove_gold(gold)
      @gold -= gold
      check_and_set_gold
    end

    # Removes the item, if it exists, and, at most, the given amount from the inventory.
    #
    # @param [Item] item the item being removed.
    # @param [Integer] amount the amount of the item to remove.
    def remove_item(item, amount = 1)
      # Decrease the amount if the item already exists in the inventory.
      @inventory.each_with_index do |couple, index|
        next unless couple.first == item
        couple.second -= amount

        # Delete the item if the amount becomes non-positive.
        @inventory.delete_at(index) if couple.second.nonpositive?

        return
      end
    end

    # Sets the Entity's gold to the number in the argument.
    # Only nonnegative numbers are accepted.
    #
    # @param [Integer] gold the amount of gold to set.
    def set_gold(gold)
      @gold = gold
      check_and_set_gold
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
      current_stats = @stats || { max_hp: 1, hp: nil, attack: 1, defense: 1, agility: 1 }
      constructed_stats = current_stats.merge(passed_in_stats)

      # Set hp to max_hp if hp not specified
      constructed_stats[:hp] = constructed_stats[:hp] || constructed_stats[:max_hp]
      # hp should not be greater than max_hp
      constructed_stats[:hp] = [constructed_stats[:hp], constructed_stats[:max_hp]].min
      # ensure hp is at least 0
      constructed_stats[:hp] = constructed_stats[:hp] > 0 ? constructed_stats[:hp] : 0
      # ensure all other stats > 0
      constructed_stats.each do |key, value|
        if %i[max_hp attack defense agility].include?(key)
          constructed_stats[key] = value.nonpositive? ? 1 : value
        end
      end

      @stats = constructed_stats
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
      index = has_item(item)
      if index
        actual_item = inventory[index].first
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

    private

    # Safety function that prevents gold
    # from decreasing below 0.
    def check_and_set_gold
      @gold = 0 if @gold.negative?
    end
  end
end
