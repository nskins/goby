require 'goby'

module Goby

  # Extends upon Entity by providing a location in the
  # form of a Map and a pair of y-x location. Overrides
  # some methods to accept input during battle.
  class Player < Entity

    include WorldCommand
    include Fighter

    # Default map when no "good" map & location specified.
    DEFAULT_MAP = Map.new(tiles: [[Tile.new]])
    # Default location when no "good" map & location specified.
    DEFAULT_COORDS = C[0, 0]

    # distance in each direction that tiles are acted upon
    # used in: update_map, print_minimap
    VIEW_DISTANCE = 2

    # @param [String] name the name.
    # @param [Hash] stats hash of stats
    # @param [[C(Item, Integer)]] inventory a list of pairs of items and their respective amounts.
    # @param [Integer] gold the currency used for economical transactions.
    # @param [[BattleCommand]] battle_commands the commands that can be used in battle.
    # @param [Hash] outfit the collection of equippable items currently worn.
    # @param [Location] location at which the player should start.
    def initialize(name: "Player", stats: {}, inventory: [], gold: 0, battle_commands: [],
                   outfit: {}, location: nil)
      super(name: name, stats: stats, inventory: inventory, gold: gold, outfit: outfit)
      @saved_maps = Hash.new

      # Ensure that the map and the location are valid.
      new_map = DEFAULT_MAP
      new_coords = DEFAULT_COORDS
      if (location && location.map && location.coords)
        y = location.coords.first; x = location.coords.second
        if (location.map.in_bounds(y, x) && location.map.tiles[y][x].passable)
          new_map = location.map
          new_coords = location.coords
        end
      end

      add_battle_commands(battle_commands)

      move_to(Location.new(new_map, new_coords))
      @saved_maps = Hash.new
    end

    # Uses player input to determine the battle command.
    #
    # @return [BattleCommand] the chosen battle command.
    def choose_attack
      print_battle_commands(header = "Choose an attack:")

      input = player_input
      index = has_battle_command(input)

      #input error loop
      while !index
        puts "You don't have '#{input}'"
        print_battle_commands(header = "Try one of these:")

        input = player_input
        index = has_battle_command(input)
      end

      return @battle_commands[index]
    end

    # Requires input to select item and on whom to use it
    # during battle (Use command). Return nil on error.
    #
    # @param [Entity] enemy the opponent in battle.
    # @return [C(Item, Entity)] the item and on whom it is to be used.
    def choose_item_and_on_whom(enemy)
      index = nil
      item = nil

      # Choose the item to use.
      while !index
        print_inventory
        puts "Which item would you like to use?"
        input = player_input prompt: "(or type 'pass' to forfeit the turn): "

        return if (input.casecmp("pass").zero?)

        index = has_item(input)

        if !index
          print NO_SUCH_ITEM_ERROR
        else
          item = @inventory[index].first
        end
      end

      whom = nil

      # Choose on whom to use the item.
      while !whom
        puts "On whom will you use the item (#{@name} or #{enemy.name})?"
        input = player_input prompt: "(or type 'pass' to forfeit the turn): "

        return if (input.casecmp("pass").zero?)

        if (input.casecmp(@name).zero?)
          whom = self
        elsif (input.casecmp(enemy.name).zero?)
          whom = enemy
        else
          print "What?! Choose either #{@name} or #{enemy.name}!\n\n"
        end
      end

      return C[item, whom]
    end

    # Sends the player back to a safe location,
    # halves its gold, and restores HP.
    def die
      sleep(2) unless ENV['TEST']

      # TODO: fix next line. regen_coords could be nil or "bad."
      @location = Location.new(@location.map, @location.map.regen_coords)

      type("After being knocked out in battle,\n")
      type("you wake up in #{@location.map.name}.\n\n")

      sleep(2) unless ENV['TEST']

      # Heal the player.
      set_stats(hp: @stats[:max_hp])
    end

    # Moves the player down. Increases 'y' coordinate by 1.
    def move_down
      down_tile = C[@location.coords.first + 1, @location.coords.second]
      move_to(Location.new(@location.map, down_tile))
    end

    # Moves the player left. Decreases 'x' coordinate by 1.
    def move_left
      left_tile = C[@location.coords.first, @location.coords.second - 1]
      move_to(Location.new(@location.map, left_tile))
    end

    # Moves the player right. Increases 'x' coordinate by 1.
    def move_right
      right_tile = C[@location.coords.first, @location.coords.second + 1]
      move_to(Location.new(@location.map, right_tile))
    end

    # Safe setter function for location and map.
    #
    # @param [Location] location the new location.
    def move_to(location)

      map = location.map
      y = location.coords.first
      x = location.coords.second

      # Prevents operations on nil.
      return if map.nil?

      # Save the map.
      @saved_maps[@location.map.name] = @location.map if @location

      # Even if the player hasn't moved, we still change to true.
      # This is because we want to re-display the minimap anyway.
      @moved = true

      # Prevents moving onto nonexistent and impassable tiles.
      return if !(map.in_bounds(y, x) && map.tiles[y][x].passable)

      # Update the location and surrounding tiles.
      @location = Location.new(
        @saved_maps[map.name] ? @saved_maps[map.name] : map, location.coords)
      update_map

      tile = @location.map.tiles[y][x]
      unless tile.monsters.empty?
        # 50% chance to encounter monster (TODO: too high?)
        if [true, false].sample
          clone = tile.monsters[Random.rand(0..(tile.monsters.size-1))].clone
          battle(clone)
        end
      end
    end

    # Moves the player up. Decreases 'y' coordinate by 1.
    def move_up
      up_tile = C[@location.coords.first - 1, @location.coords.second]
      move_to(Location.new(@location.map, up_tile))
    end

    # Prints the map in regards to what the player has seen.
    # Additionally, provides current location and the map's name.
    def print_map

      # Provide some spacing from the edge of the terminal.
      3.times { print " " };

      print @location.map.name + "\n\n"

      @location.map.tiles.each_with_index do |row, r|
        # Provide spacing for the beginning of each row.
        2.times { print " " }

        row.each_with_index do |tile, t|
          print_tile(C[r, t])
        end
        print "\n"
      end

      print "\n"

      # Provide some spacing to center the legend.
      3.times { print " " }

      # Prints the legend.
      print "¶ - #{@name}'s\n       location\n\n"
    end

    # Prints a minimap of nearby tiles (using VIEW_DISTANCE).
    def print_minimap
      print "\n"
      for y in (@location.coords.first-VIEW_DISTANCE)..(@location.coords.first+VIEW_DISTANCE)
        # skip to next line if out of bounds from above map
        next if y.negative?
        # centers minimap
        10.times { print " " }
        for x in (@location.coords.second-VIEW_DISTANCE)..(@location.coords.second+VIEW_DISTANCE)
          # Prevents operations on nonexistent tiles.
          print_tile(C[y, x]) if (@location.map.in_bounds(y, x))
        end
        # new line if this row is not out of bounds
        print "\n" if y < @location.map.tiles.size
      end
      print "\n"
    end

    # Prints the tile based on the player's location.
    #
    # @param [C(Integer, Integer)] coords the y-x location of the tile.
    def print_tile(coords)
      if ((@location.coords.first == coords.first) && (@location.coords.second == coords.second))
        print "¶ "
      else
        print @location.map.tiles[coords.first][coords.second].to_s
      end
    end

    # Updates the 'seen' attributes of the tiles on the player's current map.
    #
    # @param [Location] location to update seen attribute for tiles on the map.
    def update_map(location = @location)
      for y in (location.coords.first-VIEW_DISTANCE)..(location.coords.first+VIEW_DISTANCE)
        for x in (location.coords.second-VIEW_DISTANCE)..(location.coords.second+VIEW_DISTANCE)
          @location.map.tiles[y][x].seen = true if (@location.map.in_bounds(y, x))
        end
      end
    end

    # How the Player behaves after winning a battle.
    #
    # @param [Entity] entity the Entity who lost the battle.
    def handle_victory(entity)
      type("You defeated the #{entity.name}!\n")
      super(entity)
      print "\n"
    end

    # The treasure given by a Player after losing a battle.
    #
    # @return [Item] the reward for the victor of the battle (or nil - no treasure).
    def sample_treasures
      nil
    end

    # Returns the gold given to a victorious Entity after losing a battle
    # and deducts the figure from the Player's total as necessary
    #
    # @return[Integer] the amount of gold to award the victorious Entity
    def sample_gold
      gold_lost = 0
      # Reduce gold if the player has any.
      if @gold.positive?
        type("Looks like you lost some gold...\n\n")
        gold_lost = @gold/2
        @gold -= gold_lost
      end
      gold_lost
    end

    attr_reader :map, :location, :saved_maps
    attr_accessor :moved

  end

end
