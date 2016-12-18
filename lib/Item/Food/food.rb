require_relative '../item.rb'

class Food < Item

  # @param [String] name the name.
  # @param [Integer] price the cost in a shop.
  # @param [Boolean] consumable upon use, the item is lost when true.
  # @param [Integer] recovers the amount of HP recovered when used.
  def initialize(name: "Food", price: 0, consumable: true, recovers: 0)
    super(name: name, price: price, consumable: consumable)
    @recovers = recovers
  end

  # Heals the entity.
  #
  # @param [Entity] entity the one on whom the food is used.
  def use(entity)
    if entity.hp + recovers > entity.max_hp
      this_recover = entity.max_hp - entity.hp
      entity.hp = entity.max_hp
    else
      this_recover = @recovers
      entity.hp += @recovers
    end
    print effects_message(entity, this_recover)
  end

  # A message displaying how much HP the entity recovers.
  #
  # @param [Entity] entity the one on whom the food is used.
  # @param [Integer] recover the amount of HP that will be recovered.
  def effects_message(entity, recover)
    "#{entity.name} uses #{name} and recovers #{recover}"\
    " HP!\n\nHP: #{entity.hp}/#{entity.max_hp}\n\n"
  end

  # The amount of HP that the food recovers.
  attr_reader :recovers

end
