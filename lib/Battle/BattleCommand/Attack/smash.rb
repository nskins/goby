require_relative 'attack.rb'

# PRESET DATA
class Smash < Attack
  def initialize
    super(name: "Smash", strength: 10, success_rate: 80)
  end
end
