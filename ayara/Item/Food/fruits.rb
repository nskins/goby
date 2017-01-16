require_relative '../../../lib/Item/Food/food.rb'

class Grape < Food
  def initialize
    super(name: "Grape", price: 1, recovers: 1)
  end
end

class Apple < Food
  def initialize
    super(name: "Apple", price: 5, recovers: 3)
  end
end

class Strawberry < Food
  def initialize
    super(name: "Strawberry", price: 6, recovers: 4)
  end
end