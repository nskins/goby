class Item

  def initialize(params = {})
    @name = params[:name] || "Item"
    @price = params[:price] || 0

    if params[:consumable].nil? then @consumable = true
    else @consumable = params[:consumable] end
    
  end

  def use(entity)
    puts "Nothing happens.\n\n"
  end

  # Equality operator (subject to change).
  def ==(rhs)
    return (@name.casecmp(rhs.name) == 0)
  end

  def to_s
    @name
  end

  attr_accessor :name, :price, :consumable

end
