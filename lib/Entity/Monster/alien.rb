require_relative 'monster.rb'
require_relative '../../Battle/BattleCommand/Attack/kick.rb'

# PRESET DATA
class Alien < Monster
  def initialize
    super(name: "Alien", max_hp: 30, attack: 6, defense: 2, agility: 2, 
          inventory: [Couple.new(Donut.new, 1)], battle_commands: [Kick.new, Use.new], gold: 20, 
          message: "\"I come from another world.\"")
  end
  
  def choose_attack
    if ((@hp < 10) && !@inventory.empty?)
      return @battle_commands[1] # Use
    else
      return @battle_commands[0] # Kick
    end
  end
  
  def choose_item_and_on_whom(enemy)
    item = @inventory[0].first # Donut
    whom = self
    return Couple.new(item, whom)
  end
end