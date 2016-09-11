require_relative 'item.rb'

class Shovel < Item
  def initialize(params = { name: "Shovel", consumable: false })
    super(params)
  end

  def use(entity)
    type("\"Type 'dig' to use me when the time arises...\"\n\n")
  end
end
