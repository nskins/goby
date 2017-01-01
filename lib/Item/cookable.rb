require_relative 'Food/food.rb'

class Cookable < Item
  def initialize(name: "Cookable", price: 0, consumable: false,
                 cooked: Food.new)
    super(name: name, price: price, consumable: consumable)
    @cooked = cooked
  end
  
  def use(user, entity)
    print "#{@name} needs to be cooked first!\n\n"
  end
  
  attr_accessor :cooked
end

# Cooking failure.
class BurntFlub < Item
  def initialize
    super(name: "Burnt Flub", consumable: false)
  end
end