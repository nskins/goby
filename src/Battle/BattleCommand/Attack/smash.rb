require_relative 'attack.rb'

class Smash < Attack
  
  def initialize(params = {})
    @name = "Smash"
    @damage = 10
    @success_rate = 80
    @weapon_attack = true
  end

end
