require_relative '../util.rb'

class Entity

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
    
    if hp.nil?
      @hp = @max_hp
    else
      @hp = hp
    end
    (@max_hp = @hp) if (@hp > @max_hp)
    
    @attack = attack
    @defense = defense
    @agility = agility
    @inventory = inventory
    @gold = gold
    
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
  # @return [Couple(Item, Entity)]
  def choose_item_and_on_whom(enemy)
    item = @inventory[Random.rand(@inventory.length)].first
    whom = [self, enemy].sample
    return Couple.new(item, whom)
  end

  # Equips the specified item to the entity's outfit.
  #
  # @param [Item, String] item the item (or its name) to equip.
  def equip_item(item)

    index = has_item(item)
    if (index != -1)
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
      print "What?! You don't have THAT!\n\n"
    end
  end

  # Returns the index of the specified command, if it exists.
  #
  # @param [BattleCommand, String] cmd the battle command (or its name).
  # @return [Integer] the index of an existing command. Otherwise -1.
  def has_battle_command(cmd)
    @battle_commands.each_with_index do |command, index|
      if (command.name.casecmp(cmd.to_s) == 0)
        return index
      end
    end
    return -1
  end

  # Returns the index of the specified item, if it exists.
  #
  # @param [Item, String] item the item (or its name).
  # @return [Integer] the index of an existing item. Otherwise -1.
  def has_item(item)
    inventory.each_with_index do |couple, index|
      if (couple.first.name.casecmp(item.to_s) == 0)
        return index
      end
    end

    return -1
  end

  # Prints the available battle commands.
  #
  # @param [Boolean] verbose when true, prints the commands' descriptions.
  def print_battle_commands(verbose)
    puts "Battle Commands:" if verbose
    @battle_commands.each do |command|
      print "❊ #{command.name} \n"
      print command.description if verbose
    end
    print "\n" unless verbose
  end

  # Prints the inventory in a nice format.
  def print_inventory
    print "Current gold in pouch: #{@gold}.\n\n"

    if (@inventory.empty?)
      puts "#{@name}'s inventory is empty!"
    else
      puts "#{@name}'s inventory:"

      @inventory.each do |couple|
        puts couple.first.name + " (#{couple.second})"
      end
    end

    print "\n"
  end

  # Prints the status in a nice format.
  def print_status
    puts "HP: #{@hp}/#{@max_hp}"
    puts "Attack: #{@attack}"
    puts "Defense: #{@defense}"
    puts "Agility: #{@agility}"
    print "\n"

    print "Weapon: "
    if @outfit[:weapon]
      puts "#{@outfit[:weapon].name}"
    else
      puts "none"
    end

    print "Shield: "
    if @outfit[:shield]
      puts "#{@outfit[:shield].name}"
    else
      puts "none"
    end

    print "Helmet: "
    if @outfit[:helmet]
      puts "#{@outfit[:helmet].name}"
    else
      puts "none"
    end

    print "Torso: "
    if @outfit[:torso]
      puts "#{@outfit[:torso].name}"
    else
      puts "none"
    end

    print "Legs: "
    if @outfit[:legs]
      puts "#{@outfit[:legs].name}"
    else
      puts "none"
    end

    print "\n"
    print_battle_commands(true)
    print "\n"
  end

  # Removes the battle command, if it exists, from the entity's collection.
  #
  # @param [BattleCommand] command the command being removed.
  def remove_battle_command(command)
    index = has_battle_command(command)
    if (index >= 0)
      @battle_commands.delete_at(index)
    end
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
        if (couple.second <= 0)
          @inventory.delete_at(index)
        end

        return
      end
    end
  end

  # Unequips the specified item from the entity's outfit.
  #
  # @param [Item, String] item the item (or its name) to unequip.
  def unequip_item(item)
    pair = @outfit.detect { |type, value| value.name.casecmp(item.to_s) == 0 }
    if pair
      # On a successful find, the "detect" method always returns
      # an array of length 2; thus, the following line should not fail.
      item = pair[1]
      item.unequip(self)
      add_item(item)
    else
      print "You are not equipping THAT!\n\n"
    end
  end

  # Uses the item, if it exists, on the specified entity.
  #
  # @param [Item, String] item the item (or its name) to use.
  # @param [Entity] entity the entity on which to use the item.
  def use_item(item, entity)
    index = has_item(item)
    if (index != -1)
      actual_item = inventory[index].first
      actual_item.use(self, entity)
      remove_item(actual_item) if actual_item.consumable
    else
      print "What?! You don't have THAT!\n\n"
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

  # The inventory is stored as an array of Couple objects.
  attr_accessor :inventory
  attr_accessor :gold

  # The outfit is stored as a hash where the key
  # is the outfit component (weapon, helmet, etc.)
  # and the value is the associated equipped item.
  attr_accessor :outfit

  attr_reader :battle_commands

  attr_accessor :escaped


end
