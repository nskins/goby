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
    @description = params[:description] || "    Damage: #{@damage}\n"\
                                           "    Success Rate: #{@success_rate}%\n"

  end

  # Inflicts damage on the enemy based on user's stats.
  #
  # @param [Entity] user the one who is using the attack.
  # @param [Entity] enemy the one on whom the attack is used.
  def run(user, enemy)
    if (Random.rand(100) < @success_rate)

      multiplier = 1

      if enemy.defense > user.attack

        # RANDOMIZE ATTACK
        inflict = Random.new.rand(0.05..0.15).round(2)
        multiplier = 1 - ((enemy.defense * 0.1) - (user.attack * inflict))


        if multiplier < 0
          multiplier = 0
        end

      else
        # RANDOMIZE ATTACK
        inflict = Random.new.rand(0.05..0.15).round(2)
        multiplier = 1 + ((user.attack * inflict) - (enemy.defense * 0.1))

      end

      enemy.hp -= (@damage * multiplier).round(0)

      if enemy.hp < 0
        enemy.hp = 0
      end

      if multiplier > 0
        type("#{user.name} uses #{@name} and it is successful, ")
        type("bringing #{enemy.name}'s HP down to #{enemy.hp}.")

      else
        type("#{user.name} uses #{@name}, but #{enemy.name}'s defense ")
        type("is too high so there's no effect.")
      end
      print "\n\n"

    else
      type("#{user.name} tries to use #{@name}, but it fails.\n\n")
    end

  end

	attr_accessor :damage, :success_rate

end
