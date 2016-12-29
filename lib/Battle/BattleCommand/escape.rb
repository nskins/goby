require_relative 'battle_command.rb'

# Allows an Entity to try to escape from the opponent.
class Escape < BattleCommand
  def initialize
    super(name: "Escape")
  end

  # Samples a probability to determine if the user will escape from battle.
  #
  # @param [Entity] user the one who is trying to escape.
  # @param [Entity] monster the one from whom the user wants to escape.
  def run(user, enemy)
    sum = enemy.agility + user.agility
    random_number = Random.rand(0..sum - 1)

    # Higher probability of escape when the enemy has low agility.
    if (random_number < user.agility)
      user.escaped = true
      type("#{user.name} successfully escapes the clutches of the #{enemy.name}!\n\n")
      return
    end

    # Should already be false.
    user.escaped = false
    type("#{user.name} is cornered!\n\n")
  end

end
