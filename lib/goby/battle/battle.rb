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
      type("#{@entity_a.name} enters a battle with #{@entity_b.name}!\n\n")
      until @pair.any?(&:dead?)
        # Determine order of attacks
        total_agility = @pair.sum { |entity| entity.stats[:agility] }
        attackers = Random.rand(0..total_agility - 1) < @entity_a.stats[:agility] ? @pair : @pair.reverse

        # Both choose an attack.
        attacks = attackers.zip(attackers.reverse).map do |attacker, enemy|
          [attacker.choose_attack, attacker, enemy]
        end

        attacks.each do |attack, attacker, enemy|
          # The attacker runs its attack on the other attacker.
          attack.run(attacker, enemy)

          if attacker.escaped
            attacker.escaped = false
            return
          end

          return @pair.detect { |entity| !entity.dead? } if @pair.any?(&:dead?)
        end
      end
    end
  end
end
