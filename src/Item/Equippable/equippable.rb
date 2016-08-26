require_relative '../item.rb'

class Equippable < Item
  def initialize(params = {})
    super(params)
    @name = params[:name] || "Equippable"

    if params[:consumable].nil? then @consumable = false
    else @consumable = params[:consumable] end

    @stat_change = params[:stat_change] || StatChange.new({})
    @type = :equippable
  end

  def equip(entity)
    prev_item = entity.outfit[@type]

    entity.outfit[@type] = self
    alter_stats(self, entity, true)

    if (!prev_item.nil?)
      alter_stats(prev_item, entity, false)
      entity.add_item(prev_item)
    end

    print "#{entity.name} equips #{@name}!\n\n"
  end

  def unequip(entity)
    entity.outfit.delete(@type)
    alter_stats(self, entity, false)

    print "#{entity.name} unequips #{@name}!\n\n"
  end

  def use(entity)
    print "Type 'equip #{@name}' to equip this item.\n\n"
  end

  attr_accessor :stat_change, :type
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
