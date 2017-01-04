require_relative '../cookable.rb'

class Egg < Cookable
  def initialize
    super(name: "Egg", price: 2, cooked: BoiledEgg.new)
  end
end

class BoiledEgg < Food
  def initialize
    super(name: "Boiled Egg", price: 3, recovers: 2)
  end
end

class ScrambledEggs < Food
  def initialize
    super(name: "Scrambled Eggs", price: 25, recovers: 12)
  end
end