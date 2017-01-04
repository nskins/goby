require_relative 'attack.rb'

class FlyingKick < Attack
  def initialize
    super(name: "Flying Kick", strength: 6, success_rate: 60)
  end
end