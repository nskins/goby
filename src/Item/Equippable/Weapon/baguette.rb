require_relative 'weapon.rb'
require_relative '../../../Battle/BattleCommand/Attack/smash.rb'

class Baguette < Weapon

  def initialize(params = {})
    @name = "Baguette"
    @price = 40
    @stat_change = StatChange.new(attack: 8, defense: 2)
    @attack = Smash.new
  end

end
