require 'goby'

module Goby

  # Provides the ability to fight, equip/unequip weapons & armor,
  # and carry items & gold.
  class Entity

    # Error when the entity specifies a non-existent item.
    NO_SUCH_ITEM_ERROR = "What?! You don't have THAT!\n\n"
    # Error when the entity specifies an item not equipped.
    NOT_EQUIPPED_ERROR = "You are not equipping THAT!\n\n"

    # @param [String] name the name.
    # @param [Hash] stats hash of stats
    # @option stats [Integer] :max_hp maximum health points. Set to be positive.
    # @option stats [Integer] :hp current health points. Set to be nonnegative.
    # @option stats [Integer] :attack strength in battle. Set to be positive.
    # @option stats [Integer] :defense protection from attacks. Set to be positive.
    # @option stats [Integer] :agility speed of commands in battle. Set to be positive.
    # @param [[C(Item, Integer)]] inventory a list of pairs of items and their respective amounts.
    # @param [Integer] gold the currency used for economical transactions.
    # @param [[BattleCommand]] battle_commands the commands that can be used in battle.
    # @param [Hash] outfit the collection of equippable items currently worn.
    def initialize(name: "Entity", stats: {}, inventory: [], gold: 0, battle_commands: [], outfit: {})
      @name = name
      set_stats(stats)
      @inventory = inventory
      set_gold(gold)

      @battle_commands = battle_commands
      # Maintain sorted battle commands.
      @battle_commands.sort!{ |x,y| x.name <=> y.name }

      # See its attr_accessor below.
      @outfit = {}
      outfit.each do |type,value|
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

      # Increase the amount if the item already exists in the inventory.
      @inventory.each do |couple|
        if (couple.first == item)
          couple.second += amount
          return
        end
      end

      # If not already in the inventory, push a couple.
      @inventory.push(C[item, amount])
    end

    # Adds the specified gold and treasures to the inventory.
    #
    # @param [Integer] gold the amount of gold.
    # @param [[Item]] treasures the list of treasures.
    def add_loot(gold, treasures)
      type("Loot: ")
      if ((gold.positive?) || (treasures && treasures.any?))
        print "\n"
        if gold.positive?
          type("* #{gold} gold\n")
          add_gold(gold)
        end
        if treasures && treasures.any?
          treasures.each do |treasure|
            unless treasure.nil?
              type("* #{treasure.name}\n")
              add_item(treasure)
            end
          end
        end
        print "\n"
      else
        type("nothing!\n\n")
      end
    end

    # Removes all items from the entity's inventory.
    def clear_inventory
      while @inventory.size.nonzero?
        @inventory.pop
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
        if (defined? actual_item.equip)
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
        return index if couple.first.name.casecmp(item.to_s).zero?
      end
      return
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
      puts "Stats:"
      puts "* HP: #{@stats[:hp]}/#{@stats[:max_hp]}"
      puts "* Attack: #{@stats[:attack]}"
      puts "* Defense: #{@stats[:defense]}"
      puts "* Agility: #{@stats[:agility]}"
      print "\n"

      puts "Equipment:"
      print "* Weapon: "
      puts @outfit[:weapon] ? "#{@outfit[:weapon].name}" : "none"

      print "* Shield: "
      puts @outfit[:shield] ? "#{@outfit[:shield].name}" : "none"

      print "* Helmet: "
      puts @outfit[:helmet] ? "#{@outfit[:helmet].name}" : "none"

      print "* Torso: "
      puts @outfit[:torso] ? "#{@outfit[:torso].name}" : "none"

      print "* Legs: "
      puts @outfit[:legs] ? "#{@outfit[:legs].name}" : "none"

      print "\n"

      if self.respond_to?(:battle_commands) && !battle_commands.empty?
        puts "Battle Commands:"
        print_battle_commands
      end
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
        if (couple.first == item)
          couple.second -= amount

          # Delete the item if the amount becomes non-positive.
          @inventory.delete_at(index) if couple.second.nonpositive?

          return
        end
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
      #ensure hp is at least 0
      constructed_stats[:hp] = constructed_stats[:hp] > 0 ? constructed_stats[:hp] : 0
      #ensure all other stats > 0
      constructed_stats.each do |key,value|
        if [:max_hp, :attack, :defense, :agility].include?(key)
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
      pair = @outfit.detect { |type, value| value.name.casecmp(item.to_s).zero? }
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

    attr_accessor :name

    attr_accessor :inventory
    attr_reader :gold

    attr_reader :outfit

    attr_reader :battle_commands

    attr_accessor :escaped

    private

      # Safety function that prevents gold
      # from decreasing below 0.
      def check_and_set_gold
        @gold = 0 if @gold.negative?
      end

  end

end
