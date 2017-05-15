require 'goby'

module Goby

  # Describes a collection of Entity by providing
  # a location in the form of a Map and a pair of
  # y-x coordinates. Also provides method of battle.
  class Party

    include WorldCommand

    # Default map when no "good" map & location specified.
    DEFAULT_MAP = Map.new(tiles: [ [Tile.new] ])
    # Default location when no "good" map & location specified.
    DEFAULT_LOCATION = Couple.new(0,0)

    # Distance in each direction that tiles are acted upon.
    # Used in: update_map, print_minimap.
    VIEW_DISTANCE = 2

    # @param [Array(Entity)] members the entities in this party.
    # @param [Map] map the map on which the party is located.
    # @param [Couple(Integer, Integer)] location the 2D index of the map (the exact tile).
    def initialize(members: [], gold: 0, inventory: [],
                   map: DEFAULT_MAP, location: DEFAULT_LOCATION)
      @members = []
      members.each { |member| add_member(member) }
      set_gold(gold)
      @inventory = []
      inventory.each { |couple| add_item(couple.first, couple.second) }

      # Ensure that the map and the location are valid.
      @map = DEFAULT_MAP
      @location = DEFAULT_LOCATION
      if map && location
        y = location.first; x = location.second
        if map.in_bounds(y,x) && map.tiles[y][x].passable
          move_to(location, map)
        end
      end

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

      # If not already in the inventory, push a Couple.
      @inventory.push(Couple.new(item, amount))
    end

    # Adds a member to the 'members' variable.
    #
    # @param [Entity] member the entity to add to 'members'.
    def add_member(member)
      raise(RuntimeError, "#{member.name} already exists!") if has_member(member)
      @members << member
    end

    # Adds the specified gold and treasure item to the inventory.
    #
    # @param [Integer] gold the amount of gold.
    # @param [Item] treasure the treasure item.
    def add_rewards(gold, treasure)
      if ((gold.positive?) || treasure)
        type("Rewards:\n")
        if gold.positive?
          type("* #{gold} gold\n")
          add_gold(gold)
        end
        if treasure
          type("* #{treasure.name}\n")
          add_item(treasure)
        end
      print "\n"
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

    # Returns the index of the specified member, if it exists.
    #
    # @param [Entity, String] member the member (or its name).
    # @return [Integer] the index of an existing member. Otherwise nil.
    def has_member(member)
      @members.each_with_index do |mem, index|
        return index if mem.name.casecmp(member.to_s).zero?
      end
      return
    end

    # Safe setter function for location and map.
    #
    # @param [Couple(Integer, Integer)] coordinates the new location.
    # @param [Map] map the (possibly) new map.
    def move_to(coordinates, map = @map)
      # Prevents operations on nil.
      return if map.nil?

      system("clear") unless ENV['TEST']

      y = coordinates.first; x = coordinates.second

      # Prevents moving onto nonexistent and impassable tiles.
      if (!map.in_bounds(y,x) || (!map.tiles[y][x].passable))
        describe_tile(self)
        return
      end

      @map = map
      @location = coordinates
      tile = @map.tiles[y][x]

      update_map

      if !(tile.monsters.empty?)
        # 50% chance to encounter monster.
        if [true, false].sample
          clone = tile.monsters[Random.rand(0..(tile.monsters.size-1))].clone
          battle(clone)
        end
      end

      describe_tile(self)
    end

    # Prints the inventory in a nice format.
    def print_inventory
      print "Current gold in pouch: #{@gold}.\n\n"

      if @inventory.empty?
        print "Party's inventory is empty!\n\n"
        return
      end

      puts "Party's inventory:"
      @inventory.each do |couple|
        puts "* #{couple.first.name} (#{couple.second})"
      end
      print "\n"
    end

    # Prints the map in regards to what the party has seen.
    # Additionally, provides current location and the map's name.
    def print_map

      # Provide some spacing from the edge of the terminal.
      3.times { print " " };

      print @map.name + "\n\n"

      @map.tiles.each_with_index do |row, r|
        # Provide spacing for the beginning of each row.
        2.times { print " " }

        row.each_with_index do |tile, t|
          print_tile(Couple.new(r, t))
        end
  			print "\n"
      end

      print "\n"

      # Provide some spacing to center the legend.
      3.times { print " " }

      # Prints the legend.
      print "¶ - Party's\n       location\n\n"
    end

    # Prints a minimap of nearby tiles (using VIEW_DISTANCE).
    def print_minimap
      print "\n"
      for y in (@location.first-VIEW_DISTANCE)..(@location.first+VIEW_DISTANCE)
        # skip to next line if out of bounds from above map
        next if y.negative?
        # centers minimap
        10.times { print " " }
        for x in (@location.second-VIEW_DISTANCE)..(@location.second+VIEW_DISTANCE)
          # Prevents operations on nonexistent tiles.
          print_tile(Couple.new(y, x)) if (@map.in_bounds(y,x))
        end
        # new line if this row is not out of bounds
        print "\n" if y < @map.tiles.size
      end
      print "\n"
    end

    # Prints the tile based on the party's location.
    #
    # @param [Couple(Integer, Integer)] coords the y-x coordinates of the tile.
    def print_tile(coords)
      if ((@location.first == coords.first) && (@location.second == coords.second))
        print "¶ "
      else
        print @map.tiles[coords.first][coords.second].to_s
      end
    end

    # Removes up to the amount of gold given in the argument.
    # Party's gold will not be less than zero.
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

    # Removes a member from the 'members' variable.
    #
    # @param [Entity] member the entity to remove from 'members'.
    def remove_member(member)
      index = has_member(member)
      return unless index
      @members.delete_at(index)
    end

    # Sets the Party's gold to the number in the argument.
    # Only nonnegative numbers are accepted.
    #
    # @param [Integer] gold the amount of gold to set.
    def set_gold(gold)
      @gold = gold
      check_and_set_gold
    end

    # Updates the 'seen' attributes of the tiles on the party's current map.
    #
    # @param [Couple(Integer, Integer)] coordinates to update seen attribute for tiles on the map.
    def update_map(coordinates = @location)
      for y in (coordinates.first-VIEW_DISTANCE)..(coordinates.first+VIEW_DISTANCE)
        for x in (coordinates.second-VIEW_DISTANCE)..(coordinates.second+VIEW_DISTANCE)
          @map.tiles[y][x].seen = true if (@map.in_bounds(y,x))
        end
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

    # TODO: better data structure for 'members'?
    attr_reader :members, :map, :location, :gold
    attr_accessor :inventory

    private

      # Safety function that prevents gold from decreasing below 0.
      def check_and_set_gold
        @gold = 0 if @gold.negative?
      end

  end

end