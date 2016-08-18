require_relative 'attack.rb'

class Kick < Attack
  def initialize(params = {})
    @name = "Kick"
    @damage = params[:damage] || 5
    @success_rate = params[:success_rate] || 99
    @weapon_attack = params[:weapon_attack] || false
  end

end
