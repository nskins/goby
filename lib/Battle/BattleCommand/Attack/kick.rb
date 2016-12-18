require_relative 'attack.rb'

# PRESET DATA
class Kick < Attack
  def initialize
    super(name: "Kick", strength: 5, success_rate: 99)
  end
end

