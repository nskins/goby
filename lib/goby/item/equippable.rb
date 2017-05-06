module Goby

  # Provides methods for equipping & unequipping an Item.
  module Equippable

    # The function that returns the type of the item.
    # Subclasses must override this function.
    #
    def stat_change
      raise(NotImplementedError, 'An Equippable Item must implement a stat_change Hash')
    end

    # The function that returns the change in stats for when the item is equipped.
    # Subclasses must override this function.
    #
    def type
      raise(NotImplementedError, 'An Equippable Item must have a type')
    end
    
    # Alters the stats of the entity
    #
    # @param [Entity] entity the entity equipping/unequipping the item.
    # @param [Boolean] equipping flag for when the item is being equipped or unequipped.
    # @todo ensure stats cannot go below zero (but does it matter..?).
    def alter_stats(entity, equipping)
        
      # Alter the stats as appropriate.
      # TODO: this can be simplified by creating entity.stats hash..?
      if equipping
        entity.attack += stat_change[:attack] if stat_change[:attack]
        entity.defense += stat_change[:defense] if stat_change[:defense]
        entity.agility += stat_change[:agility] if stat_change[:agility]
      else
        entity.attack -= stat_change[:attack] if stat_change[:attack]
        entity.defense -= stat_change[:defense] if stat_change[:defense]
        entity.agility -= stat_change[:agility] if stat_change[:agility]
      end
      
    end

    # Equips onto the entity and changes the entity's attributes accordingly.
    #
    # @param [Entity] entity the entity who is equipping the equippable.
    def equip(entity)
      prev_item = entity.outfit[type]

      entity.outfit[type] = self
      alter_stats(entity, true)

      if prev_item
        prev_item.alter_stats(entity, false)
        entity.add_item(prev_item)
      end

      print "#{entity.name} equips #{@name}!\n\n"
    end

    # Unequips from the entity and changes the entity's attributes accordingly.
    #
    # @param [Entity] entity the entity who is unequipping the equippable.
    def unequip(entity)
      entity.outfit.delete(type)
      alter_stats(entity, false)

      print "#{entity.name} unequips #{@name}!\n\n"
    end

    # The function that executes when one uses the equippable.
    #
    # @param [Entity] user the one using the item.
    # @param [Entity] entity the one on whom the item is used.
    def use(user, entity)
      print "Type 'equip #{@name}' to equip this item.\n\n"
    end

  end

end