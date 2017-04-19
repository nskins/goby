require_relative '../battle_command.rb'

class Attack < BattleCommand

  # @param [String] name the name.
  # @param [Integer] strength the strength.
  # @param [Integer] success_rate the chance of success.
  def initialize(name: "Attack", strength: 1, success_rate: 100)
    super(name: name)
    @strength = strength
    @success_rate = success_rate
  end

  # Inflicts damage on the enemy and prints output.
  #
  # @param [Entity] user the one who is using the attack.
  # @param [Entity] enemy the one on whom the attack is used.
  def run(user, enemy)
    if (Random.rand(100) < @success_rate)

      # Damage the enemy.
      original_enemy_hp = enemy.hp
      damage = calculate_damage(user, enemy)
      enemy.hp -= damage

      # Prevent HP < 0.
      enemy.hp = 0 if enemy.hp < 0

      type("#{user.name} uses #{@name}!\n\n")
      type("#{enemy.name} takes #{original_enemy_hp - enemy.hp} damage!\n")
      type("#{enemy.name}'s HP: #{original_enemy_hp} -> #{enemy.hp}\n\n")

    else
      type("#{user.name} tries to use #{@name}, but it fails.\n\n")
    end

  end

  # Determine how much damage this attack will do on the enemy.
  #
  # @param [Entity] user the one using the attack.
  # @param [Entity] enemy the one on whom the attack is used.
  # @return [Integer] the amount of damage to inflict on the enemy.
  def calculate_damage(user, enemy)

    # RANDOMIZE ATTACK
    inflict = Random.rand(0.05..0.15).round(2)
    multiplier = 1

    if enemy.defense > user.attack
      multiplier = 1 - ((enemy.defense * 0.1) - (user.attack * inflict))

      # Prevent a negative multiplier.
      multiplier = 0 if multiplier < 0

    else
      multiplier = 1 + ((user.attack * inflict) - (enemy.defense * 0.1))
    end

    return (@strength * multiplier).round(0)
  end

  attr_accessor :strength, :success_rate

end