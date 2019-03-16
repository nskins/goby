require 'goby'

module Goby

  # Methods and variables for something that can battle with another Fighter.
  module Fighter

    # Exception thrown when a non-Fighter tries to enter battle.
    class UnfightableException < Exception
    end

    # The function that handles how an Fighter behaves after losing a battle.
    # Subclasses must override this function.
    def die
      raise(NotImplementedError, 'A Fighter must know how to die.')
    end

    # Handles how a Fighter behaves after winning a battle.
    # Subclasses must override this function.
    #
    # @param [Fighter] fighter the Fighter who lost the battle.
    def handle_victory(fighter)
      raise(NotImplementedError, 'A Fighter must know how to handle victory.')
    end

    # The function that returns the treasure given by a Fighter after losing a battle.
    #
    # @return [Item] the reward for the victor of the battle (or nil - no treasure).
    def sample_treasures
      raise(NotImplementedError, 'A Fighter must know whether it returns treasure or not after losing a battle.')
    end

    # The function that returns the gold given by a Fighter after losing a battle.
    #
    # @return[Integer] the amount of gold to award the victorious Fighter
    def sample_gold
      raise(NotImplementedError, 'A Fighter must return some gold after losing a battle.')
    end

    # Adds the specified battle command to the Fighter's collection.
    #
    # @param [BattleCommand] command the command being added.
    def add_battle_command(command)
      battle_commands.push(command)

      # Maintain sorted battle commands.
      battle_commands.sort! { |x, y| x.name <=> y.name }
    end

    # Adds the specified battle commands to the Fighter's collection.
    #
    # @param [Array] battle_commands the commands being added.
    def add_battle_commands(battle_commands)
      battle_commands.each { |command| add_battle_command(command) }
    end

    # Engages in battle with the specified Entity.
    #
    # @param [Entity] entity the opponent of the battle.
    def battle(entity)
      unless entity.class.included_modules.include?(Fighter)
        raise(UnfightableException, "You can't start a battle with an Entity of type #{entity.class} as it doesn't implement the Fighter module")
      end
      system("clear") unless ENV['TEST']

      battle = Battle.new(self, entity)
      winner = battle.determine_winner

      if winner.equal?(self)
        handle_victory(entity)
        entity.die
      elsif winner.equal?(entity)
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

    # Determines how the Fighter should select an attack in battle.
    # Override this method for control over this functionality.
    #
    # @return [BattleCommand] the chosen battle command.
    def choose_attack
      battle_commands[Random.rand(@battle_commands.length)]
    end

    # Determines how the Fighter should select the item and on whom
    # during battle (Use command). Return nil on error.
    #
    # @param [Fighter] enemy the opponent in battle.
    # @return [C(Item, Fighter)] the item and on whom it is to be used.
    def choose_item_and_on_whom(enemy)
      item = @inventory[Random.rand(@inventory.length)].first
      whom = [self, enemy].sample
      return C[item, whom]
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

    # Removes the battle command, if it exists, from the Fighter's collection.
    #
    # @param [BattleCommand, String] command the command being removed.
    def remove_battle_command(command)
      index = has_battle_command(command)
      battle_commands.delete_at(index) if index
    end

    # Prints the available battle commands.
    #
    # @param [String] header the text to output as a heading for the list of battle commands.
    def print_battle_commands(header = "Battle Commands:")
      puts header
      battle_commands.each do |command|
        print "❊ #{command.name}\n"
      end
      print "\n"
    end

    # Appends battle commands to the end of the Fighter print_status output.
    def print_status
      super
      print_battle_commands unless battle_commands.empty?
    end

    def escape_from(enemy)
      # Higher probability of escape when the enemy has low agility.
      sum = enemy.stats[:agility] + stats[:agility]
      self.escaped = Random.rand(sum) < stats[:agility]
    end

    def choose_and_use_item_on(enemy)
      pair = choose_item_and_on_whom(enemy)
      use_item(pair.first, pair.second) if pair
    end
  end

end