# frozen_string_literal: true

require 'goby'

module Goby

  # Recovers HP when used.
  class Food < Item

    # @param [String] name the name.
    # @param [Integer] price the cost in a shop.
    # @param [Boolean] consumable upon use, the item is lost when true.
    # @param [Boolean] disposable allowed to sell or drop item when true.
    # @param [Integer] recovers the amount of HP recovered when used.
    def initialize(name: "Food", price: 0, consumable: true, disposable: true, recovers: 0)
      super(name: name, price: price, consumable: consumable, disposable: disposable)
      @recovers = recovers
    end

    # Heals the entity.
    #
    # @param [Entity] user the one using the food.
    # @param [Entity] entity the one on whom the food is used.
    def use(user, entity)
      if entity.stats[:hp] + recovers > entity.stats[:max_hp]
        this_recover = entity.stats[:max_hp] - entity.stats[:hp]
        heal_entity(entity, entity.stats[:max_hp])
      else
        current_hp = entity.stats[:hp]
        this_recover = @recovers
        heal_entity(entity, current_hp + this_recover)
      end

      # Helpful output.
      print "#{user.name} uses #{name}"
      if (user == entity)
        print " and "
      else
        print " on #{entity.name}!\n#{entity.name} "
      end
      print "recovers #{this_recover} HP!\n\n"
      print "#{entity.name}'s HP: #{entity.stats[:hp]}/#{entity.stats[:max_hp]}\n\n"

    end

    # The amount of HP that the food recovers.
    attr_reader :recovers

    private

      #sets the hp of entity to new_hp
      def heal_entity(entity, new_hp)
        entity.set_stats(hp: new_hp)
      end

  end

end