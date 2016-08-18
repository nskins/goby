require_relative '../item.rb'

class Equippable < Item
  def initialize(params = {})
    super(params)
    @name = params[:name] || "Equippable"
    @stat_change = params[:stat_change] || StatChange.new({})
  end

  # REQUIRES: The entity is actually unequipping such an item.
  # Override this method to remove the appropriate equippable.
  # See weapon.rb and helmet.rb for example overrides.
  def unequip(entity)
    # ERROR
  end

  attr_accessor :stat_change

  protected

    # This method should never be called outside of the 'use' method.
    def equip(entity, prev_item)
      alter_stats(self, entity, true)

      # Updates stats when the entity had a previous item equipped.
      if (!prev_item.nil?)
        restore_status(prev_item, entity)
      end

      print "#{self.name} is now equipped!\n\n"
    end

end

# Defines the stats that change when equipping the equippable item.
class StatChange
  def initialize(params)
    @attack = params[:attack] || 0
    @defense = params[:defense] || 0
  end

  def ==(rhs)
    if (@attack == rhs.attack && @defense == rhs.defense)
      return true
    end
    return false
  end

  attr_accessor :attack, :defense
end

# TODO: ensure nothing goes below zero.
def alter_stats(item, entity, equipping)
  if equipping
    entity.attack += item.stat_change.attack
    entity.defense += item.stat_change.defense
  else
    entity.attack -= item.stat_change.attack
    entity.defense -= item.stat_change.defense
  end
end

def restore_status(prev_item, entity)
  alter_stats(prev_item, entity, false)
  entity.add_item(prev_item)
end
