require 'goby'

module Goby

  # Representation of a fight between two Fighters.
  class Battle

    # @param [Entity] entity_a the first entity in the battle
    # @param [Entity] entity_b the second entity in the battle
    def initialize(entity_a, entity_b)
      @entity_a = entity_a
      @entity_b = entity_b
    end

    # Determine the winner of the battle
    #
    # @return [Entity] the winner of the battle
    def determine_winner
      type("#{entity_a.name} enters a battle with #{entity_b.name}!\n\n")
      until someone_dead?
        #Determine order of attacks
        attackers = determine_order

        # Both choose an attack.
        attacks = attackers.map { |attacker| attacker.choose_attack }

        2.times do |i|
          # The attacker runs its attack on the other attacker.
          attacks[i].run(attackers[i], attackers[(i + 1) % 2])

          if (attackers[i].escaped)
            attackers[i].escaped = false
            return
          end

          break if someone_dead?
        end
      end

      # If @entity_a is dead set winner to @entity_b, otherwise @entity_a
      winner = entity_a.stats[:hp] <=0 ? entity_b : entity_a
      # Sets loser to entity with 0 or less hp
      loser = entity_a.stats[:hp] <=0 ? entity_a : entity_b
      if winner.class != Monster
        # Gain XP based on opponent
        gain_xp(winner, loser)
        # Check if winner can level up
        winner.check_level
        # return winner
      end
      winner
    end

    private

    # Determine the order of attack based on the entitys' agilities
    #
    # @return [Array] the entities in the order of attack
    def determine_order
      sum = entity_a.stats[:agility] + entity_b.stats[:agility]
      random_number = Random.rand(0..sum - 1)

      if random_number < entity_a.stats[:agility]
        [entity_a, entity_b]
      else
        [entity_b, entity_a]
      end
    end

    # Check if either entity is is dead
    #
    # @return [Boolean] whether an entity is dead or not
    def someone_dead?
      entity_a.stats[:hp] <= 0 || entity_b.stats[:hp] <= 0
    end

    # Gain XP based on defeated opponent
    #
    # @param [Entity] the winner of the battle
    # @param [Entity] the loser of the battle
    # @return [Integer] the amount of xp gained
    def gain_xp(winner, loser)
      # Monsters should not level up fighting players
      if winner.class != Monster
        # Different Mechanics for monster vs pvp
        if loser.class == Monster
          # Gain monsters XP
          xp = winner[:xp] + loser[:xp]
        else
          # Calculate XP gain based on level difference
          level_diff = winner[:level] - loser[:level]
          # About 10 victories to level up
          if level_diff == 0
            xp = (winner.nextLevel(winner[:level]) * 0.01).floor
          # 10% more XP for each level down
          elsif level_diff > 0
            xp = (winner.nextLevel(winner[:level]) * 0.01 * level_diff).floor
          else
            amount = 0.01-0.001 * level_diff
            # Minimum XP gain
            if amount <= 0
              amount = 0.001
            end
            xp = (winner.nextLevel(winner[:level]) * amount).floor
          end
        end
        winner.set_stats(xp: xp)
      end
      xp
    end

    attr_reader :entity_a, :entity_b
  end

end
