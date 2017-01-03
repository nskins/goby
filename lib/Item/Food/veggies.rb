require_relative 'food.rb'

class Celery < Food
  def initialize
    super(name: "Celery", price: 2, recovers: 1)
  end
end

class Onion < Food
  def initialize
    super(name: "Onion", price: 3, recovers: 1)
  end
end

class Potato < Food
  def initialize
    super(name: "Potato", price: 4, recovers: 2)
  end
end

class Tomato < Food
  def initialize
    super(name: "Tomato", price: 6, recovers: 3)
  end
end

class Pepper < Food
  def initialize
    super(name: "Pepper", price: 8, recovers: 4)
  end
end