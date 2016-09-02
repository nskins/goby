require_relative '../item.rb'

class Food < Item

  # @param [Hash] params the parameters for creating a Food.
  # @option params [String] :name the name.
  # @option params [Integer] :price the cost in a shop.
  # @option params [Boolean] :consumable determines whether the food is lost when used.
  # @option params [Integer] :recovers the amount of HP recovered when used.
  def initialize(params = {})
    super(params)
    @name = params[:name] || "Food"
    @recovers = params[:recovers] || 0
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
