require_relative 'shop.rb'
require_relative '../../Item/Food/donut.rb'
require_relative '../../Item/Equippable/Weapon/baguette.rb'

# PRESET DATA
class Bakery < Shop
  def initialize
    super(name: "Bob's Bakery", items: [Donut.new, Baguette.new])
  end
end
