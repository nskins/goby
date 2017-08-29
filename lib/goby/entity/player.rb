require 'goby'

module Goby

  # Extends upon Entity by providing a location in the
  # form of a Map and a pair of y-x coordinates. Overrides
  # some methods to accept input during battle.
  class Player < Entity

    include WorldCommand

    # Default map when no "good" map & location specified.
    DEFAULT_MAP = Map.new(tiles: [ [Tile.new] ])
    # Default location when no "good" map & location specified.
    DEFAULT_LOCATION = C[0,0]

    # distance in each direction that tiles are acted upon
    # used in: update_map, print_minimap
    VIEW_DISTANCE = 2

    # @param [String] name the name.
    # @param [Hash] stats hash of stats
    # @param [[C(Item, Integer)]] inventory a list of pairs of items and their respective amounts.
    # @param [Integer] gold the currency used for economical transactions.
    # @param [[BattleCommand]] battle_commands the commands that can be used in battle.
    # @param [Hash] outfit the collection of equippable items currently worn.
    # @param [Map] map the map on which the player is located.
    # @param [C(Integer,Integer)] location the 2D index of the map (the exact tile).
    def initialize(name: "Player", stats: {}, inventory: [], gold: 0, battle_commands: [],
                   outfit: {}, map: nil, location: nil)
      super(name: name, stats: stats, inventory: inventory, gold: gold, battle_commands: battle_commands, outfit: outfit)
      @saved_maps = Hash.new

      # Ensure that the map and the location are valid.
      new_map = DEFAULT_MAP
      new_location = DEFAULT_LOCATION
      if (map && location)
        y = location.first; x = location.second
        if (map.in_bounds(y,x) && map.tiles[y][x].passable)
          new_map = map
          new_location = location
        end
      end

      move_to(new_location, new_map)
      @saved_maps = Hash.new
    end

    # Engages in battle with the specified monster.
    #
    # @param [Monster] monster the opponent of the battle.
    def battle(monster)
      system("clear") unless ENV['TEST']
      puts "#{monster.message}\n"
      type("You've run into a vicious #{monster.name}!\n\n")

      while stats[:hp].positive?
        # Both choose an attack.
        player_attack = choose_attack

        # Prevents the user from using "bad" commands.
        # Example: "Use" with an empty inventory.
        while (player_attack.fails?(self))
          player_attack = choose_attack
        end

        monster_attack = monster.choose_attack

        attackers = Array.new
        attacks = Array.new

        if sample_agilities(monster)
          attackers << self << monster
          attacks << player_attack << monster_attack
        else
          attackers << monster << self
          attacks << monster_attack << player_attack
        end

        2.times do |i|
          # The attacker runs its attack on the other attacker.
          attacks[i].run(attackers[i], attackers[(i + 1) % 2])

          if (attackers[i].escaped)
            attackers[i].escaped = false
            return
          end

          break if monster.stats[:hp].nonpositive? || stats[:hp].nonpositive?

        end

        break if monster.stats[:hp].nonpositive? || stats[:hp].nonpositive?

      end

      die if stats[:hp].nonpositive?

      if monster.stats[:hp].nonpositive?
        type("You defeated the #{monster.name}!\n\n")

        # Determine the rewards for defeating the monster.
        rewards = monster.sample_rewards
        gold = rewards.first
        treasure = rewards.second

        add_loot(gold, [treasure])
      end

    end

    # Uses player input to determine the battle command.
    #
    # @return [BattleCommand] the chosen battle command.
    def choose_attack
      puts "Choose an action:"
      print_battle_commands

      input = player_input
      index = has_battle_command(input)

      #input error loop
      while !index
        puts "You don't have '#{input}'"
        puts "Try one of these:"
        print_battle_commands

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

      # TODO: fix next line. regen_location could be nil or "bad."
      @location = @map.regen_location

      type("After being knocked out in battle,\n")
      type("you wake up in #{@map.name}.\n\n")

      # Reduce gold if the player has any.
      if @gold.positive?
        type("Looks like you lost some gold...\n\n")
        @gold /= 2
      end

      sleep(2) unless ENV['TEST']

      # Heal the player.
      set_stats(hp: @stats[:max_hp])
    end

    # Moves the player down. Increases 'y' coordinate by 1.
    def move_down
      down_tile = C[@location.first + 1, @location.second]
      move_to(down_tile)
    end

    # Moves the player left. Decreases 'x' coordinate by 1.
    def move_left
      left_tile = C[@location.first, @location.second - 1]
      move_to(left_tile)
    end

    # Moves the player right. Increases 'x' coordinate by 1.
    def move_right
      right_tile = C[@location.first, @location.second + 1]
      move_to(right_tile)
    end

    # Safe setter function for location and map.
    #
    # @param [C(Integer, Integer)] coordinates the new location.
    # @param [Map] map the (possibly) new map.
    def move_to(coordinates, map = @map)
      # Prevents operations on nil.
      return if map.nil?

      system("clear") unless ENV['TEST']

      y = coordinates.first; x = coordinates.second

      # Save the map.
      @saved_maps[@map.name] = @map if @map

      # Prevents moving onto nonexistent and impassable tiles.
      if (!map.in_bounds(y,x) || (!map.tiles[y][x].passable))
        describe_tile(self)
        return
      end

      @map = @saved_maps[map.name] ? @saved_maps[map.name] : map
      @location = coordinates
      tile = @map.tiles[y][x]

      update_map

      unless tile.monsters.empty?
        # 50% chance to encounter monster.
        if [true, false].sample
          clone = tile.monsters[Random.rand(0..(tile.monsters.size-1))].clone
          battle(clone)
        end
      end

      describe_tile(self)
    end

    # Moves the player up. Decreases 'y' coordinate by 1.
    def move_up
      up_tile = C[@location.first - 1, @location.second]
      move_to(up_tile)
    end

    # Prints the map in regards to what the player has seen.
    # Additionally, provides current location and the map's name.
    def print_map

      # Provide some spacing from the edge of the terminal.
      3.times { print " " };

      print @map.name + "\n\n"

      @map.tiles.each_with_index do |row, r|
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
      for y in (@location.first-VIEW_DISTANCE)..(@location.first+VIEW_DISTANCE)
        # skip to next line if out of bounds from above map
        next if y.negative?
        # centers minimap
        10.times { print " " }
        for x in (@location.second-VIEW_DISTANCE)..(@location.second+VIEW_DISTANCE)
          # Prevents operations on nonexistent tiles.
          print_tile(C[y, x]) if (@map.in_bounds(y,x))
        end
        # new line if this row is not out of bounds
        print "\n" if y < @map.tiles.size
      end
      print "\n"
    end

    # Prints the tile based on the player's location.
    #
    # @param [C(Integer, Integer)] coords the y-x coordinates of the tile.
    def print_tile(coords)
      if ((@location.first == coords.first) && (@location.second == coords.second))
        print "¶ "
      else
        print @map.tiles[coords.first][coords.second].to_s
      end
    end

    # Uses the agility levels of the player and monster to determine who should go first.
    #
    # @param [Monster] monster the opponent with whom the player is competing.
    # @return [Boolean] true when player should go first. Otherwise, false.
    def sample_agilities(monster)
      sum = monster.stats[:agility] + stats[:agility]
      Random.rand(sum) < stats[:agility]
    end

    # Updates the 'seen' attributes of the tiles on the player's current map.
    #
    # @param [C(Integer, Integer)] coordinates to update seen attribute for tiles on the map
    def update_map(coordinates = @location)
      for y in (coordinates.first-VIEW_DISTANCE)..(coordinates.first+VIEW_DISTANCE)
        for x in (coordinates.second-VIEW_DISTANCE)..(coordinates.second+VIEW_DISTANCE)
          @map.tiles[y][x].seen = true if (@map.in_bounds(y,x))
        end
      end
    end

    attr_reader :map, :location, :saved_maps

  end

end
