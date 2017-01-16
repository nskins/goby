require_relative '../../lib/Item/item.rb'

class FishingPole < Item
  def initialize
    super(name: "Fishing Pole", price: 10, consumable: false)
  end
end