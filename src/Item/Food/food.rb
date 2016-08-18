require_relative '../item.rb'

class Food < Item

  def initialize(params = {})
    super(params)
    @name = params[:name] || "Food"
    @recovers = params[:recovers] || 0
  end

  def use(entity)
    entity.hp += @recovers

    # Prevents HP > max HP.
    if (entity.hp > entity.max_hp)
      entity.hp = entity.max_hp
    end

  end

  # The amount of HP that the food recovers.
  attr_reader :recovers

end
