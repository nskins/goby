require_relative 'entity.rb'
require_relative '../world_command.rb'
require_relative '../Map/Map/map.rb'
require_relative '../Map/Tile/tile.rb'

# Extends upon Entity by providing a location in the
# form of a Map and a pair of y-x coordinates. Overrides
# some methods to accept input during battle.
class Player < Entity

  include WorldCommand

  # Default map when no "good" map & location specified.
  DEFAULT_MAP = Map.new(tiles: [ [Tile.new] ])
  # Default location when no "good" map & location specified.
  DEFAULT_LOCATION = Couple.new(0,0)

  # distance in each direction that tiles are acted upon
  # used in: update_map, print_minimap
  VIEW_DISTANCE = 2

  # @param [String] name the name.
  # @param [Integer] max_hp the greatest amount of health.
  # @param [Integer] hp the current amount of health.
  # @param [Integer] attack the strength in battle.
  # @param [Integer] defense the prevention of attack power on oneself.
  # @param [Integer] agility the speed in battle.
  # @param [[Couple(Item, Integer)]] inventory a list of pairs of items and their respective amounts.
  # @param [Integer] gold the currency used for economical transactions.
  # @param [[BattleCommand]] battle_commands the commands that can be used in battle.
  # @param [Hash] outfit the collection of equippable items currently worn.
  # @param [Map] map the map on which the player is located.
  # @param [Couple(Integer,Integer)] location the 2D index of the map (the exact tile).
  def initialize(name: "Player", max_hp: 1, hp: nil, attack: 1, defense: 1, agility: 1,
                 inventory: [], gold: 0, battle_commands: [], outfit: {}, map: DEFAULT_MAP,
                 location: DEFAULT_LOCATION)
    super(name: name, max_hp: max_hp, hp: hp, attack: attack, defense: defense, agility: agility,
          inventory: inventory, gold: gold, battle_commands: battle_commands, outfit: outfit)

    @map = DEFAULT_MAP
    @location = DEFAULT_LOCATION

    # Ensure that the map and the location are valid.
    if (map && location)

      y = location.first; x = location.second

      if (map.in_bounds(y,x) && map.tiles[y][x].passable)
        move_to(location, map)
      end
    end

  end

  # Engages in battle with the specified monster.
  #
  # @param [Monster] monster the opponent of the battle.
  def battle(monster)
    system("clear") unless ENV['TEST']
    puts "#{monster.message}\n"
    type("You've run into a vicious #{monster.name}!\n\n")

    while hp > 0
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

        break if monster.hp <= 0 || hp <= 0

      end

      break if monster.hp <= 0 || hp <= 0

    end

    die if hp <= 0

    if monster.hp <= 0
      type("You defeated the #{monster.name}!\n\n")

      # Determine the rewards for defeating the monster.
      rewards = monster.sample_rewards
      gold = rewards.first
      treasure = rewards.second

      add_rewards(gold, treasure)
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
  # @return [Couple(Item, Entity)] the item and on whom it is to be used.
  def choose_item_and_on_whom(enemy)
    index = nil
    item = nil

    # Choose the item to use.
    while !index
      print_inventory
      puts "Which item would you like to use?"
      print "(or type 'pass' to forfeit the turn): "
      input = gets.chomp

      print "\n"

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
      print "(or type 'pass' to forfeit the turn): "
      input = gets.chomp

      print "\n"

      return if (input.casecmp("pass").zero?)

      if (input.casecmp(@name).zero?)
        whom = self
      elsif (input.casecmp(enemy.name).zero?)
        whom = enemy
      else
        print "What?! Choose either #{@name} or #{enemy.name}!\n\n"
      end
    end

    return Couple.new(item, whom)
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
    if @gold > 0
      type("Looks like you lost some gold...\n\n")
      @gold /= 2
    end

    sleep(2) unless ENV['TEST']

    # Heal the player.
    @hp = @max_hp
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

  # Moves the player right. Increases 'x' coordinate by 1.
  def move_right
    right_tile = Couple.new(@location.first, @location.second + 1)
    move_to(right_tile)
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

  # Moves the player up. Decreases 'y' coordinate by 1.
  def move_up
    up_tile = Couple.new(@location.first - 1, @location.second)
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
        print_tile(Couple.new(r, t))
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
      next if y < 0
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

  # Prints the tile based on the player's location.
  #
  # @param [Couple(Integer, Integer)] coords the y-x coordinates of the tile.
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
    sum = monster.agility + agility
    Random.rand(sum) < agility
  end

  # Updates the 'seen' attributes of the tiles on the player's current map.
  # 
  # @param [Couple(Integer, Integer)] coordinates to update seen attribute for tiles on the map 
  def update_map(coordinates = @location)
    for y in (coordinates.first-VIEW_DISTANCE)..(coordinates.first+VIEW_DISTANCE)
      for x in (coordinates.second-VIEW_DISTANCE)..(coordinates.second+VIEW_DISTANCE)
        @map.tiles[y][x].seen = true if (@map.in_bounds(y,x))
      end
    end
  end

  attr_reader :map, :location

end
