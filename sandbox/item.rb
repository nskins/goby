class Item

  def use(entity)
    puts "Nothing happens."
  end

  # Equality operator.
  def ==(rhs)
    return (@name == rhs.name)
  end

  attr_accessor :name, :price

end

class Bait < Item
  def use(entity)
    puts "This should be used at a fishing spot."
  end
end

class Food < Item

  # The amount of hp that the food recovers.
  attr_reader :recovers

  def use(entity)
    entity.hp += @recovers

    # Prevents hp > max_hp.
    if (entity.hp > entity.max_hp)
      entity.hp = entity.max_hp
    end
  end

end

# ~~~$$$~~~Baits~~~$$$~~~#

class Chub < Bait
  # Used for Raw Weakfish.
  def initialize
    @name = "Chub"
    @price = 3
  end
end

# ~~~$$$~~~Foods~~~$$$~~~#

class Banana < Food
  def initialize
    @name = "Banana"
    @price = 2
    @recovers = 2
  end
end

# ~~~$$$~~~Items~~~$$$~~~#

class Bucket < Item
  def initialize
    @name = "Bucket"
    @price = 2
  end
end

class FishingPole < Item
  def initialize
    @name = "Fishing Pole"
    @price = 15
  end
end

class Fuel < Item
  # Override use on boat's Tile?
  def initialize
    @name = "Fuel"
    @price = 30
  end
end
