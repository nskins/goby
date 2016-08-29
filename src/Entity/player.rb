require 'deep_clone'
require_relative 'entity.rb'
require_relative '../world_command.rb'
require_relative '../Battle/BattleCommand/escape.rb'

class Player < Entity

  def initialize(params = {})
    super(params)
    @name = params[:name] || "Player"
    @map = params[:map] || nil
    @location = params[:location] || nil

    update_map
  end

  def choose_attack
    puts "Choose an action:"
    print_battle_commands

    input = player_input
    index = has_battle_command_by_string(input)

    #input error loop
    while (index == -1)
      puts "You don't have '#{input}'"
      puts "Try one of these:"
      print_battle_commands

      input = player_input
      index = has_battle_command_by_string(input)
    end

    return @battle_commands[index]
	end

  def die
    @location = @map.regen_location
    type("After being knocked out in battle, you wake up in #{@map.name}\n")
    type("Looks like you lost some gold...\n\n")
    sleep(2)
    @gold /= 2
    @hp = @max_hp
  end

  def move_to(coordinates, map = @map)
    # Prevents operations on nil.
    return if (@map.nil? || map.nil?)

    y = coordinates.first; x = coordinates.second

    # Prevents moving onto nonexistent and impassable tiles.
    if (!@map.in_bounds(y,x) ||
       (!@map.tiles[y][x].passable))
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

  def move_north
    north_tile = Couple.new(@location.first - 1, @location.second)
    move_to(north_tile)
  end

  def move_east
    east_tile = Couple.new(@location.first, @location.second + 1)
    move_to(east_tile)
  end

  def move_south
    south_tile = Couple.new(@location.first + 1, @location.second)
    move_to(south_tile)
  end

  def move_west
    west_tile = Couple.new(@location.first, @location.second - 1)
    move_to(west_tile)
  end

  def update_map
    # Prevents operations on nil.
    return if (@map.nil?)

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

  attr_accessor :map, :location

end
