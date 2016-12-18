require_relative 'legs.rb'

# PRESET DATA
class RippedPants < Legs
  def initialize
    super(name: "Ripped Pants", price: 25, stat_change: {defense: 3})
  end
end
