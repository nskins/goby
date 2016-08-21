require_relative 'battle_command.rb'

class Escape < BattleCommand
  def initialize(params = {})
    @name = "Escape"
  end

  def run(user, enemy)
    #the less HP the enemy has, the higher prob. of run succeeding.
    #variables for readability
    weakness = enemy.hp/enemy.max_hp
    chance = ((weakness * 5) + 1).to_i

    # Chance might be too low?
    if (Random.rand(chance) == 0)
      user.escaped = true
      type("#{user.name} successfully escapes the clutches of the #{enemy.name}!\n\n")
      return
    end

    # Should already be false.
    user.escaped = false
    type("#{user.name} is cornered!\n\n")
  end

end
