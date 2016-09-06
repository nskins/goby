require_relative '../item.rb'

class Equippable < Item

  # @param [Hash] params the parameters for creating an Equippable.
  # @option params [String] :name the name.
  # @option params [Integer] :price the cost in a shop.
  # @option params [Boolean] :consumable determines whether the item is lost when used.
  # @option params [StatChange] :stat_change the change in stats for when the item is equipped.
  def initialize(params = {})
    super(params)
    @name = params[:name] || "Equippable"

    # Equippables are consumed through the entity's equip_item function.
    if params[:consumable].nil? then @consumable = false
    else @consumable = params[:consumable] end

    @stat_change = params[:stat_change] || StatChange.new
    @type = :equippable
  end

  # Equips onto the entity and changes the entity's attributes accordingly.
  #
  # @param [Entity] entity the entity who is equipping the equippable.
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

  # Unequips from the entity and changes the entity's attributes accordingly.
  #
  # @param [Entity] entity the entity who is unequipping the equippable.
  def unequip(entity)
    entity.outfit.delete(@type)
    alter_stats(self, entity, false)

    print "#{entity.name} unequips #{@name}!\n\n"
  end

  # The function that executes when one uses the equippable.
  #
  # @param [Entity] entity the one on whom the item is used.
  def use(entity)
    print "Type 'equip #{@name}' to equip this item.\n\n"
  end

  attr_accessor :stat_change, :type
end

# Defines the stats that change when equipping the equippable item.
class StatChange

  # @param [Hash] params the parameters for creating a StatChange.
  # @option params [Integer] :attack the amount by which to increase attack.
  # @option params [Integer] :defense the amount by which to increase defense.
  def initialize(params = {})
    @attack = params[:attack] || 0
    @defense = params[:defense] || 0
  end

  # @param [StatChange] rhs the stat change on the right.
  def ==(rhs)
    if (@attack == rhs.attack && @defense == rhs.defense)
      return true
    end
    return false
  end

  attr_accessor :attack, :defense
end

# Alters the stats of the entity
#
# @param [Equippable] item the item being equipped/unequipped.
# @param [Entity] entity the entity equipping/unequipping the item.
# @param [Boolean] equipping flag for when the item is being equipped or unequipped.
# @todo switch to Equippable member function.
# @todo ensure stats cannot go below zero.
def alter_stats(item, entity, equipping)
  if equipping
    entity.attack += item.stat_change.attack
    entity.defense += item.stat_change.defense
  else
    entity.attack -= item.stat_change.attack
    entity.defense -= item.stat_change.defense
  end
end
