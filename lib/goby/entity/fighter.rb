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

    # Engages in battle with the specified entity.
    #
    # @param [Entity] entity the opponent of the battle.
    def battle(entity)
      raise("Entity of type #{Entity.class} does not know how to fight") unless entity.fighter?
      system("clear") unless ENV['TEST']
      puts "#{entity.message}\n"
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

    #
    #
    def fighter?
      true
    end

    # The function that handles how an Entity behaves after winning a battle.
    #
    # @param [Entity] entity the Entity who lost the battle.
    def handle_victory(entity)
      # Determine the rewards for defeating the entity.
      gold = entity.sample_gold
      treasure = entity.sample_treasures

      add_loot(gold, [treasure]) unless gold.nil? && treasure.nil?
    end

    # The function that returns the gold given by an Entity after losing a battle.
    #
    # @return[Integer] the amount of gold to award the victorious Entity
    def sample_gold
      # Sample a random amount of gold.
      Random.rand(0..@gold)
    end

  end

end