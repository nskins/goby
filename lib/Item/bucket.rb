require_relative 'item.rb'

class Bucket < Item
  def initialize
    super(name: "Bucket", price: 5, consumable: false)
  end
end