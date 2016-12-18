require_relative 'item.rb'

class Shovel < Item
  def initialize
    super(name: "Shovel", consumable: false)
  end

  def use(entity)
    type("\"Type 'dig' to use me when the time arises...\"\n\n")
  end
end
