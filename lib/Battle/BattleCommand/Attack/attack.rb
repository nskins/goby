require_relative '../battle_command.rb'

class Attack < BattleCommand

  # @param [Hash] params the parameters for creating an Attack.
  # @option params [String] :name the name.
  # @option params [Integer] :strength the strength.
  # @option params [Integer] :success_rate the chance of success.
  def initialize(params = {})
    super(params)
    @name = params[:name] || "Attack"
    @strength = params[:strength] || 0
    @success_rate = params[:success_rate] || 100
    @description = params[:description] || "    Strength: #{@strength}\n"\
                                           "    Success Rate: #{@success_rate}%\n"

  end

  # Inflicts damage on the enemy and prints output.
  #
  # @param [Entity] user the one who is using the attack.
  # @param [Entity] enemy the one on whom the attack is used.
  def run(user, enemy)
    if (Random.rand(100) < @success_rate)
      
      original_enemy_hp = enemy.hp
      damage = calculate_damage(user, enemy)
      enemy.hp -= damage

      if enemy.hp < 0
        enemy.hp = 0
      end
      
      type("#{user.name} uses #{@name}!\n\n")
      type("#{enemy.name} takes #{original_enemy_hp - enemy.hp} damage!\n")
      type("#{enemy.name}'s HP: #{original_enemy_hp} -> #{enemy.hp}\n\n")  

    else
      type("#{user.name} tries to use #{@name}, but it fails.\n\n")
    end

  end
  
  def calculate_damage(user, enemy)
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
    
    return (@strength * multiplier).round(0)
  end

	attr_accessor :strength, :success_rate

end
