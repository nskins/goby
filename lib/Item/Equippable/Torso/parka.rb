require_relative 'torso.rb'

# PRESET DATA
class Parka < Torso
  def initialize
    super(name: "Parka", price: 40, stat_change: {defense: 4})
  end
end
