require_relative 'food.rb'

# PRESET DATA
class Donut < Food
  def initialize
    super(name: "Donut", price: 10, recovers: 15)
  end
end
