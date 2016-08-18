require_relative 'util.rb'

class Entity

  # Change constructor...
  def initialize(name, max_hp = 5, hp = 3)
    @name = name
    @max_hp = max_hp
    @hp = hp
    @inventory = []
    @gold = 0
  end

  # Adds the item and the given amount to the inventory.
  def add_item(item, amount)
    # Check if the Entity already has that item
    # in the inventory. If so, just increase
    # the amount.
    @inventory.each do |couple|
      if (couple.first == item)
        couple.second += amount
        return
      end
    end
    # If not already in the inventory, push a Couple.
    @inventory.push(Couple.new(item, amount))
  end

  # Requires an Item as the argument.
  # Returns the index of that item, if it exists.
  # Otherwise, returns -1.
  def has_item_by_object(item)
    inventory.each_with_index do |couple, index|
      if (couple.first == item)
        return index
      end
    end
    return -1
  end

  # Requires a String as the argument.
  # Returns the index of that item, if it exists.
  # Otherwise, returns -1.
  def has_item_by_string(name)
    inventory.each_with_index do |couple, index|
      if (couple.first.name == name)
        return index
      end
    end
    return -1
  end

  # Removes the item and, at most, the given amount
  # from the inventory
  def remove_item(item, amount)
    # Check if the Entity already has that item
    # in the inventory. If so, just decrease
    # the amount.
    @inventory.each_with_index do |couple, index|
      if (couple.first == item)
        couple.second -= amount
        if (couple.second <= 0)
          @inventory.delete_at(index)
        end
        return
      end
    end
  end

  # Prints the inventory in a nice format.
  def print_inventory
    @inventory.each do |couple|
      puts couple.first.name + " (#{couple.second})"
    end
  end

  # Automatically creates getter and setter methods.
  attr_accessor :name
  attr_accessor :max_hp, :hp

  # The inventory is stored as an array
  # of Couple objects. The first data type
  # is the item's name. The second data type
  # is its count in the inventory.
  attr_accessor :inventory, :gold

end
