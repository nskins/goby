require_relative 'food.rb'

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

class Watermelon < Item
  def initialize
    super(name: "Watermelon", price: 10)
  end
  
  def use(user, entity)
    # TODO: check for knife.
    puts "You can't eat it whole!"
    print "Cut it up with a knife!\n\n"
  end
end

class WatermelonSlice < Food
  def initialize
    super(name: "Watermelon Slice", price: 4, recovers: 4)
  end
end