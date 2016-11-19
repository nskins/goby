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
    if (params[:map] && params[:location])

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
        clone = tile.monsters[Random.rand(0..(tile.monsters.size-1))].clone
        battle(clone)
      end

    end

    describe_tile(self)
  end

  # Moves the player up. Decreases 'y' coordinate by 1.
  def move_up
    up_tile = Couple.new(@location.first - 1, @location.second)
    move_to(up_tile)
  end

  # Moves the player right. Increases 'x' coordinate by 1.
  def move_right
    right_tile = Couple.new(@location.first, @location.second + 1)
    move_to(right_tile)
  end

  # Moves the player down. Increases 'y' coordinate by 1.
  def move_down
    down_tile = Couple.new(@location.first + 1, @location.second)
    move_to(down_tile)
  end

  # Moves the player left. Decreases 'x' coordinate by 1.
  def move_left
    left_tile = Couple.new(@location.first, @location.second - 1)
    move_to(left_tile)
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
  # Additionally, provides current location and the map's name.
  def print_map
    
    # Provide some spacing to center the name.
    (0..(@map.name.length/4)).each do
      print " "
    end
  
    print @map.name + "\n\n"
    
    @map.tiles.each_with_index do |row, r|
      # Provide spacing for the beginning of each row.
      (0..(@map.name.length/2)).each do
        print " "
      end
      row.each_with_index do |tile, t|
        if ((@location.first == r) && (@location.second == t))
          print "¶ "
        elsif (!tile.seen)
          print "  "
        else
          print tile.graphic + " "
        end
      end
			print "\n"
    end
    
    print "\n"
    
    # Provide some spacing to center the legend.
    (0..(@map.name.length/4)).each do
      print " "
    end
    
    # Prints the legend.
    puts "¶ - #{@name}'s \n       location\n\n"
  end

  # Engages in battle with the specified monster.
  #
  # @param [Monster] monster the opponent of the battle.

  def battle(monster)
    puts "#{monster.message}\n"
    type("You've run into a vicious #{monster.name}!\n\n")

    while hp > 0
      # Both choose an attack.
      player_attack = choose_attack
      monster_attack = monster.choose_attack
      
      attackers = Array.new
      attacks = Array.new
      
      if player_first?(monster)
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
        
        break if monster.hp <= 0 || hp <= 0
        
      end
        
      break if monster.hp <= 0 || hp <= 0

    end

    if hp <=0
      sleep(2); die
    end

    if monster.hp <= 0
      type("You defeated the #{monster.name}\n")
      gold_reward = Random.rand(0..monster.gold)
          
      if (gold_reward > 0)
        type("and they dropped #{gold_reward} gold!\n\n")
        @gold += gold_reward
      end
    end

  end

  attr_reader :map, :location

  private
  
  def player_first?(monster)
    sum = monster.agility + agility
    random_number = Random.rand(0..sum - 1)
    random_number < agility
  end

end