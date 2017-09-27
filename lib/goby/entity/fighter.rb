require 'goby'

module Goby

  module Fighter

    # The function that handles how an Entity behaves after losing a battle.
    # Subclasses must override this function.
    #
    def die
      raise(NotImplementedError, 'A Fighter Entity must know how to die')
    end

    # The function that returns the treasure given by an Entity after losing a battle.
    #
    # @return [Item] the reward for the victor of the battle (or nil - no treasure).
    def sample_treasures
      raise(NotImplementedError, 'A Fighter Entity must know whether it returns treasure or not after losing a battle')
    end

    # The function that returns the gold given by an Entity after losing a battle.
    #
    # @return[Integer] the amount of gold to award the victorious Entity
    def sample_gold
      raise(NotImplementedError, 'A Fighter Entity must return some gold after losing a battle')
    end

    # Adds the specified battle command to the entity's collection.
    #
    # @param [BattleCommand] command the command being added.
    def add_battle_command(command)
      battle_commands.push(command)

      # Maintain sorted battle commands.
      battle_commands.sort! { |x, y| x.name <=> y.name }
    end

    # Adds the specified battle commands to the entity's collection.
    #
    # @param [Array] battle_commands the commands being added.
    def add_battle_commands(battle_commands)
      battle_commands.each { |command| add_battle_command(command) }
    end

    # Engages in battle with the specified entity.
    #
    # @param [Entity] entity the opponent of the battle.
    def battle(entity)
      #TODO: Decide how best to handle if a Fighter attempt to start a battle with a non-Fighter Entity
      system("clear") unless ENV['TEST']
      puts "#{entity.message}\n" if entity.message
      type("You've run into a vicious #{entity.name}!\n\n")

      battle = Battle.new(self, entity)
      winner = battle.determine_winner

      if winner == self
        handle_victory(entity)
        entity.die
      else
        entity.handle_victory(self)
        die
      end
    end

    # Returns the Array for BattleCommands available for the Fighter.
    # Sets @battle_commands to an empty Array if it's the first time it's called.
    #
    # @return [Array] array of the available BattleCommands for the Fighter.
    def battle_commands
      @battle_commands ||= []
      @battle_commands
    end

    # Determines how the entity should select an attack in battle.
    # Override this method for control over this functionality.
    #
    # @return [BattleCommand] the chosen battle command.
    def choose_attack
      return battle_commands[Random.rand(@battle_commands.length)]
    end

    # Determines how the entity should select the item and on whom
    # during battle (Use command). Return nil on error.
    #
    # @param [Entity] enemy the opponent in battle.
    # @return [C(Item, Entity)] the item and on whom it is to be used.
    def choose_item_and_on_whom(enemy)
      item = @inventory[Random.rand(@inventory.length)].first
      whom = [self, enemy].sample
      return C[item, whom]
    end

    # A function to check if the given object has implemented the Fighter module
    #
    # @returns [Boolean] true
    def fighter?
      true
    end

    # Handles how an Entity behaves after winning a battle.
    #
    # @param [Entity] entity the Entity who lost the battle.
    def handle_victory(entity)
      # Determine the rewards for defeating the entity.
      gold = entity.sample_gold
      treasure = entity.sample_treasures

      add_loot(gold, [treasure]) unless gold.nil? && treasure.nil?
    end

    # Returns the index of the specified command, if it exists.
    #
    # @param [BattleCommand, String] cmd the battle command (or its name).
    # @return [Integer] the index of an existing command. Otherwise nil.
    def has_battle_command(cmd)
      battle_commands.each_with_index do |command, index|
        return index if command.name.casecmp(cmd.to_s).zero?
      end
      return
    end

    # The message that the Fighter says before starting a Battle.
    # Implementers should override this method with a custom message.
    #
    # @return[String] the message the Fighter will say when attacked
    def message
      ''
    end

    # Removes the battle command, if it exists, from the entity's collection.
    #
    # @param [BattleCommand, String] command the command being removed.
    def remove_battle_command(command)
      index = has_battle_command(command)
      battle_commands.delete_at(index) if index
    end

    # Prints the available battle commands.
    def print_battle_commands
      battle_commands.each do |command|
        print "❊ #{command.name}\n"
      end
      print "\n"
    end

    # Appends battle commands to the end of the Entity print_status output.
    def print_status
      super
      puts "Battle Commands:"
      print_battle_commands
    end

    # Uses the agility levels of the two Fighters to determine who should go first.
    #
    # @param [Entity] fighter the opponent with whom the calling Fighter is competing.
    # @return [Boolean] true when calling Fighter should go first. Otherwise, false.
    def sample_agilities(fighter)
      sum = fighter.stats[:agility] + stats[:agility]
      Random.rand(sum) < stats[:agility]
    end

  end

end