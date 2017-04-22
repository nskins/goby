require_relative '../util.rb'

class Entity

  NO_SUCH_ITEM_ERROR = "What?! You don't have THAT!\n\n"
  NOT_EQUIPPED_ERROR = "You are not equipping THAT!\n\n"

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
  def initialize(name: "Entity", max_hp: 1, hp: nil, attack: 1, defense: 1, agility: 1,
                 inventory: [], gold: 0, battle_commands: [], outfit: {})
    @name = name
    @max_hp = max_hp
    @hp = hp.nil? ? max_hp : hp

    # Prevent HP > max HP.
    @max_hp = @hp if @hp > @max_hp

    @attack = attack
    @defense = defense
    @agility = agility
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

  # Adds the specified battle command to the entity's collection.
  #
  # @param [BattleCommand] command the command being added.
  def add_battle_command(command)
    @battle_commands.push(command)

    # Maintain sorted battle commands.
    @battle_commands.sort!{ |x,y| x.name <=> y.name }
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

  # Adds the specified gold and treasure item to the inventory.
  #
  # @param [Integer] gold the amount of gold.
  # @param [Item] treasure the treasure item.
  def add_rewards(gold, treasure)
    if ((gold > 0) || treasure)
      type("Rewards:\n")
      if (gold > 0)
        type("* #{gold} gold\n")
        add_gold(gold)
      end
      if (treasure)
        type("* #{treasure.name}\n")
        add_item(treasure)
      end
    print "\n"
    end
  end

  # Determines how the entity should select an attack in battle.
  # Override this method for control over this functionality.
  #
  # @return [BattleCommand] the chosen battle command.
	def choose_attack
	  return @battle_commands[Random.rand(@battle_commands.length)]
	end

  # Determines how the entity should select the item and on whom
  # during battle (Use command). Return nil on error.
  #
  # @param [Entity] enemy the opponent in battle.
  # @return [Couple(Item, Entity)] the item and on whom it is to be used.
  def choose_item_and_on_whom(enemy)
    item = @inventory[Random.rand(@inventory.length)].first
    whom = [self, enemy].sample
    return Couple.new(item, whom)
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

  # Returns the index of the specified command, if it exists.
  #
  # @param [BattleCommand, String] cmd the battle command (or its name).
  # @return [Integer] the index of an existing command. Otherwise nil.
  def has_battle_command(cmd)
    @battle_commands.each_with_index do |command, index|
      return index if command.name.casecmp(cmd.to_s).zero?
    end
    return
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

  # Prints the available battle commands.
  def print_battle_commands
    @battle_commands.each do |command|
      print "❊ #{command.name}\n" 
    end
    print "\n"
  end

  # Prints the inventory in a nice format.
  def print_inventory
    print "Current gold in pouch: #{@gold}.\n\n"

    (print "#{@name}'s inventory is empty!\n\n"; return) if (@inventory.empty?)

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
    puts "* HP: #{@hp}/#{@max_hp}"
    puts "* Attack: #{@attack}"
    puts "* Defense: #{@defense}"
    puts "* Agility: #{@agility}"
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

    unless @battle_commands.empty?
      puts "Battle Commands:"
      print_battle_commands
    end
  end

  # Removes the battle command, if it exists, from the entity's collection.
  #
  # @param [BattleCommand] command the command being removed.
  def remove_battle_command(command)
    index = has_battle_command(command)
    @battle_commands.delete_at(index) if index
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
        @inventory.delete_at(index) if couple.second <= 0

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
  attr_accessor :max_hp, :hp
  attr_accessor :attack
  attr_accessor :defense
  attr_accessor :agility

  attr_accessor :inventory
  attr_reader :gold

  attr_reader :outfit

  attr_reader :battle_commands

  attr_accessor :escaped

  private

    # Safety function that prevents gold
    # from decreasing below 0.
    def check_and_set_gold
      @gold = 0 if @gold < 0
    end

end
