require_relative 'shield.rb'

# PRESET DATA
class RiotShield < Shield
  def initialize(params = { name: "Riot Shield",
                            price: 75,
                            stat_change: {defense: 8}})
    super(params)
  end
end
