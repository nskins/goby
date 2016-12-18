class Item
  
  # @param [String] name the name.
  # @param [Integer] price the cost in a shop.
  # @param [Boolean] consumable upon use, the item is lost when true.
  def initialize(name: "Item", price: 0, consumable: true)
    @name = name
    @price = price
    @consumable = consumable
  end

  # The function that executes when one uses the item.
  #
  # @param [Entity] entity the one on whom the item is used.
  def use(entity)
    puts "Nothing happens.\n\n"
  end

  # @param [Item] rhs the item on the right.
  def ==(rhs)
    return (@name.casecmp(rhs.name) == 0)
  end

  # @return [String] the name of the Item.
  def to_s
    @name
  end

  attr_accessor :name, :price, :consumable

end
