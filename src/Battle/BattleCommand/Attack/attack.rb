require_relative '../battle_command.rb'

class Attack < BattleCommand

  def initialize(params = {})
    super(params)
    @name = params[:name] || "Attack"
    # The default attack won't do any damage.
    @damage = params[:damage] || 0
    # The default attack will always succeed.
    @success_rate = params[:success_rate] || 100
    # The default attack is not attached to a weapon.
    if params[:weapon_attack].nil? then @weapon_attack = false
    else @weapon_attack = params[:weapon_attack] end
  end

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

      if (@weapon_attack)
        # TODO: fix power attribute.
        # multiplier *= user.weapon.power
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

	attr_accessor :damage, :success_rate, :weapon_attack

end
