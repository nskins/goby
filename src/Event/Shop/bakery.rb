require_relative 'shop.rb'
require_relative '../../Item/Food/donut.rb'
require_relative '../../Item/Equippable/Weapon/baguette.rb'

class Bakery < Shop

  def initialize(params = {})
    super(params)
    @name = "Bob's Bakery"
    @items = [Donut.new, Baguette.new]
  end


end
