require_relative '../battle_command.rb'

class Attack < BattleCommand

  # @param [Hash] params the parameters for creating an Attack.
  # @option params [String] :name the name.
  # @option params [Integer] :damage the strength.
  # @option params [Integer] :success_rate the chance of success.
  def initialize(params = {})
    super(params)
    @name = params[:name] || "Attack"
    @damage = params[:damage] || 0
    @success_rate = params[:success_rate] || 100
  end

  # Inflicts damage on the enemy based on user's stats.
  #
  # @param [Entity] user the one who is using the attack.
  # @param [Entity] enemy the one on whom the attack is used.
  def run(user, enemy)
    if (Random.rand(100) < @success_rate)

      multiplier = 1

      if enemy.defense > user.attack
        multiplier = 1 - ((enemy.defense * 0.1) - (user.attack * 0.1))

        if multiplier < 0
          multiplier = 0
        end

      else
        multiplier = 1 + ((user.attack * 0.1) - (enemy.defense * 0.1))
      end

      enemy.hp -= @damage * multiplier

      if enemy.hp < 0
        enemy.hp = 0
      end

      if multiplier > 0
        type("#{user.name} uses #{@name} and it is successful, ")
        type("bringing #{enemy.name}'s HP down to #{enemy.hp.round(2)}.")
      else
        type("#{user.name} uses #{@name}, but #{enemy.name}'s defense")
        type("is so high that it doesn't have any effect.")
      end
      print "\n\n"

    else
      type("#{user.name} tries to use #{@name}, but it fails.\n\n")
    end

  end

	attr_accessor :damage, :success_rate

end
