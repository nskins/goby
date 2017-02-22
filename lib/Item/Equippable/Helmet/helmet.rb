require_relative '../equippable.rb'

class Helmet < Equippable

  # @param [String] name the name.
  # @param [Integer] price the cost in a shop.
  # @param [Boolean] consumable upon use, the item is lost when true.
  # @param [Boolean] disposable allowed to sell or drop item when true.
  # @param [Hash] stat_change the change in stats for when the item is equipped.
  def initialize(name: "Helmet", price: 0, consumable: false, disposable: true, stat_change: {})
    super(name: name, price: price, consumable: consumable, disposable: disposable, stat_change: stat_change)
    @type = :helmet
  end

end
