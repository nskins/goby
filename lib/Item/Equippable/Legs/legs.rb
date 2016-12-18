require_relative '../equippable.rb'

class Legs < Equippable

  # @param [String] name the name.
  # @param [Integer] price the cost in a shop.
  # @param [Boolean] consumable upon use, the item is lost when true.
  # @param [Hash] stat_change the change in stats for when the item is equipped.
  def initialize(name: "Legs", price: 0, consumable: false, stat_change: {})
    super(name: name, price: price, consumable: consumable, stat_change: stat_change)
    @type = :legs
  end

end
