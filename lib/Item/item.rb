class Item

  # @param [Hash] params the parameters for creating an Item.
  # @option params [String] :name the name.
  # @option params [Integer] :price the cost in a shop.
  # @option params [Boolean] :consumable determines whether the item is lost when used.
  def initialize(params = {})
    @name = params[:name] || "Item"
    @price = params[:price] || 0

    if params[:consumable].nil? then @consumable = true
    else @consumable = params[:consumable] end
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
