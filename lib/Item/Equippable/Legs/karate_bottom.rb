require_relative 'legs.rb'

class KarateBottom < Legs
  def initialize
    super(name: "Karate Bottom", price: 35, stat_change: {agility: 3})
  end
end