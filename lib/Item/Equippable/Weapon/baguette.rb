require_relative 'weapon.rb'
require_relative '../../../Battle/BattleCommand/Attack/smash.rb'

# PRESET DATA
class Baguette < Weapon
  def initialize
    super(name: "Baguette", price: 40, stat_change: {attack: 8, defense: 2})
    @attack = Smash.new
  end
end
