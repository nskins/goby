require 'deep_clone'
require_relative 'entity.rb'
require_relative '../world_command.rb'
require_relative '../Map/Map/map.rb'
require_relative '../Map/Tile/tile.rb'

class Player < Entity

  DEFAULT_MAP = Map.new(tiles: [ [Tile.new] ])
  DEFAULT_LOCATION = Couple.new(0,0)

  # @param [Hash] params the parameters for creating a Player.
  # @option params [String] :name the name.
  # @option params [Integer] :max_hp the greatest amount of health.
  # @option params [Integer] :hp the current amount of health.
  # @option params [Integer] :attack the strength in battle.
  # @option params [Integer] :defense the prevention of attack power on oneself.
  # @option params [[Couple(Item, Integer)]] :inventory a list of pairs of items and their respective amounts.
  # @option params [Integer] :gold the currency used for economical transactions.
  # @option params [[BattleCommand]] :battle_commands the commands that can be used in battle.
  # @option params [Hash] :outfit the collection of equippable items currently worn.
  # @option params [Map] :map the map on which the player is located.
  # @option params [Couple(Integer,Integer)] :location the 2D index of the map (the exact tile).
  def initialize(params = {})
    super(params)
    @name = params[:name] || "Player"

    @map = DEFAULT_MAP
    @location = DEFAULT_LOCATION

    # Ensure that the map and the location are valid.
    if ((!params[:map].nil?) && (!params[:location].nil?))

      y = params[:location].first; x = params[:location].second

      if (params[:map].in_bounds(y,x) && params[:map].tiles[y][x].passable)
        @map = params[:map]
        @location = params[:location]
      end
    end

    update_map
  end

  # Uses player input to determine the battle command.
  #
  # @return [BattleCommand] the chosen battle command.
  def choose_attack
    puts "Choose an action:"
    print_battle_commands(false)

    input = player_input
    index = has_battle_command(input)

    #input error loop
    while (index == -1)
      puts "You don't have '#{input}'"
      puts "Try one of these:"
      print_battle_commands(false)

      input = player_input
      index = has_battle_command(input)
    end

    return @battle_commands[index]
	end

  # Sends the player back to a safe location, halves its gold, and restores HP.
  def die
    # TODO: fix next line. regen_location could be nil or "bad."
    @location = @map.regen_location
    type("After being knocked out in battle, you wake up in #{@map.name}\n")
    type("Looks like you lost some gold...\n\n")
    sleep(2)
    @gold /= 2
    @hp = @max_hp
  end

  # Safe setter function for location and map.
  #
  # @param [Couple(Integer,Integer)] coordinates the new location.
  # @param [Map] map the (possibly) new map.
  def move_to(coordinates, map = @map)
    # Prevents operations on nil.
    return if map.nil?

    y = coordinates.first; x = coordinates.second

    # Prevents moving onto nonexistent and impassable tiles.
    if (!@map.in_bounds(y,x) || (!@map.tiles[y][x].passable))
      print "You cannot move there!\n\n"
      print_possible_moves(self)
      return
    end

    @map = map
    @location = coordinates
    tile = @map.tiles[y][x]

    update_map

    if !(tile.monsters.empty?)
      # 50% chance of monster appearing
      monster_outcome = Random.rand(0..99)

      if (monster_outcome < 50)
        system("clear")
        clone = DeepClone.clone(tile.monsters[Random.rand(0..(tile.monsters.size-1))])
        battle(clone)
      end

    end

    describe_tile(self)
  end

  # Moves the player north. Decreases 'y' coordinate by 1.
  def move_north
    north_tile = Couple.new(@location.first - 1, @location.second)
    move_to(north_tile)
  end

  # Moves the player east. Increases 'x' coordinate by 1.
  def move_east
    east_tile = Couple.new(@location.first, @location.second + 1)
    move_to(east_tile)
  end

  # Moves the player south. Increases 'y' coordinate by 1.
  def move_south
    south_tile = Couple.new(@location.first + 1, @location.second)
    move_to(south_tile)
  end

  # Moves the player west. Decreases 'x' coordinate by 1.
  def move_west
    west_tile = Couple.new(@location.first, @location.second - 1)
    move_to(west_tile)
  end

  # Updates the 'seen' attributes of the tiles on the player's current map.
  def update_map
    for y in (@location.first-1)..(@location.first+1)
      for x in (@location.second-1)..(@location.second+1)
        # Prevents operations on nonexistent tiles.
        if (@map.in_bounds(y,x))
          @map.tiles[y][x].seen = true
        end
      end
    end

  end

  # Prints the map in regards to what the player has seen.
  def print_map

    puts "\nYou're in " + @map.name + "!\n\n"
    row_count = 0
    @map.tiles.each do |sub|
      #centers each row under the "welcome" sign
      for i in 1..(@map.name.length/2)
        print " "
      end
      col_count = 0
      sub.each do |tile|
        if tile.seen
          if tile.passable
            if row_count == @location.first && col_count == @location.second
              print "¶"
            else
              print "·"
            end
          else
            print "■"
          end
        else
          print " "
        end
        col_count += 1
      end
      row_count += 1
      puts ""
    end
    puts "\n· - passable space" +
         "\n■ - impassable space" +
         "\n¶ - your location\n\n"
  end

  # Engages in battle with the specified monster.
  #
  # @param [Monster] monster the opponent of the battle.
  def battle(monster)
    puts "#{monster.message}\n"
    type("You've run into a vicious #{monster.name}!\n\n")

    # Main battle loop.
    while hp > 0

      # Execute the player's command.
      choose_attack.run(self, monster)

      # Case: The player has successfully escaped.
      if (@escaped)
        @escaped = false
        return
      end

      if (monster.hp > 0)
        monster.choose_attack.run(monster, self)

        # Case: The monster has successfully escaped.
        if (monster.escaped)
          monster.escaped = false
          return
        end

      # Case: The monster has been defeated.
      else
      	type("You defeated the #{monster.name}\n")
        gold_reward = Random.rand(0..monster.gold)
        if (gold_reward > 0)
          type("and they dropped #{gold_reward} gold!\n")
          @gold += gold_reward
        end
        print "\n"

        return
      end

    end

    # Case: Breaking out of main battle loop => player is dead.
    sleep(2); die

  end

  attr_reader :map, :location

end
