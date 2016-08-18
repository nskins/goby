class Item

  def initialize(params = {})
    @name = params[:name] || "Item"
    @price = params[:price] || 0

    # Interesting and best way that I know of
    # to set default boolean parameters.
    if params[:consumable].nil? then @consumable = true
    else @consumable = params[:consumable] end
  end

  # Returns a boolean value which indicates if the item is consumed.
  # TODO: perhaps instead there should be a consumable variable.
  #       Then it can be accessed directly from use_item.
  #       Yes, this sounds good.
  def use(entity)
    puts "Nothing happens.\n\n"
  end

  # Equality operator (subject to change).
  def ==(rhs)
    return (@name.casecmp(rhs.name) == 0)
  end

  attr_accessor :name, :price, :consumable

end
