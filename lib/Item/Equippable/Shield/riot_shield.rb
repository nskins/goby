require_relative 'shield.rb'

# PRESET DATA
class RiotShield < Shield
  def initialize
    super(name: "Riot Shield", price: 75, stat_change: {defense: 8})
  end
end
