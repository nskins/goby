require_relative 'legs.rb'

# PRESET DATA
class RippedPants < Legs
  def initialize(params = { name: "Ripped Pants",
                            price: 25,
                            stat_change: StatChange.new(defense: 3)})
    super(params)
  end
end
