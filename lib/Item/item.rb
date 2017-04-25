# Can be used by an Entity in order to trigger anything specified.
# Placed into the Entity's inventory.
class Item

  # Default text when the Item doesn't do anything.
  DEFAULT_USE_TEXT = "Nothing happens.\n\n"

  # @param [String] name the name.
  # @param [Integer] price the cost in a shop.
  # @param [Boolean] consumable upon use, the item is lost when true.
  # @param [Boolean] disposable allowed to sell or drop item when true.
  def initialize(name: "Item", price: 0, consumable: true, disposable: true)
    @name = name
    @price = price
    @consumable = consumable
    @disposable = disposable
  end

  # The function that executes when one uses the item.
  #
  # @param [Entity] user the one using the item.
  # @param [Entity] entity the one on whom the item is used.
  def use(user, entity)
    print DEFAULT_USE_TEXT
  end

  # @param [Item] rhs the item on the right.
  def ==(rhs)
    return @name.casecmp(rhs.name).zero?
  end

  # @return [String] the name of the Item.
  def to_s
    @name
  end

  attr_accessor :name, :price, :consumable, :disposable

end
