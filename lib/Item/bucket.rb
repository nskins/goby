require_relative 'item.rb'

class Bucket < Item
  def initialize
    super(name: "Bucket", price: 1, consumable: false)
  end
end

class BucketOfWater < Item
  def initialize
    super(name: "Bucket of Water", price: 1, consumable: false)
  end
end