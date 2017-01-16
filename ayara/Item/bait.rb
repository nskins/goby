require_relative 'cookable.rb'

class Bait < Item
  def initialize(name: "Bait", price: 0, consumable: false)
    super(name: name, price: price, consumable: consumable)
  end
  
  # TODO: can use at the pool.
end

class Snail < Bait
  def initialize
    super(name: "Snail", price: 1, consumable: false)
  end
end

# Enables one to match certain species with certain bait.
class Baitable < Cookable
  def initialize(name: "Baitable", price: 0, consumable: false, 
                 cooked: Food.new, bait: Bait.new)
    super(name: name, price: price, consumable: consumable,
          cooked: cooked)
    @bait = bait
  end
  
  attr_accessor :bait
end