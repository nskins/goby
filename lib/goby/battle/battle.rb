require 'goby'

module Goby
  # Representation of a fight between two Fighters.
  class Battle
    # @param [Entity] entity_a the first entity in the battle
    # @param [Entity] entity_b the second entity in the battle
    def initialize(entity_a, entity_b)
      @entity_a = entity_a
      @entity_b = entity_b
      @pair = [entity_a, entity_b]
    end

    # Determine the winner of the battle
    #
    # @return [Entity] the winner of the battle
    def determine_winner
      type("#{entity_a.name} enters a battle with #{entity_b.name}!\n\n")
      until someone_dead?
        # Determine order of attacks
        attackers = determine_order

        # Both choose an attack.
        attacks = attackers.map(&:choose_attack)

        2.times do |i|
          # The attacker runs its attack on the other attacker.
          attacks[i].run(attackers[i], attackers[(i + 1) % 2])

          if attackers[i].escaped
            attackers[i].escaped = false
            return
          end

          break if someone_dead?
        end
      end

      @pair.detect { |entity| entity.stats[:hp] > 0 }
    end

    private

    # Determine the order of attack based on the entitys' agilities
    #
    # @return [Array] the entities in the order of attack
    def determine_order
      Random.rand(0..stats(:agility).sum - 1) < entity_a.stats[:agility] ? @pair : @pair.reverse
    end

    # Check if either entity is is dead
    #
    # @return [Boolean] whether an entity is dead or not
    def someone_dead?
      stats(:hp).any?(&:nonpositive?)
    end

    def stats(stat)
      @pair.map { |entity| entity.stats[stat] }
    end

    attr_reader :entity_a, :entity_b
  end
end
