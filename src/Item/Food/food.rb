require_relative '../item.rb'

class Food < Item

  def initialize(params = {})
    super(params)
    @name = params[:name] || "Food"
    @recovers = params[:recovers] || 0
  end

  def use(entity)
    if entity.hp + recovers > entity.max_hp
      this_recover = entity.max_hp - entity.hp
      entity.hp = entity.max_hp
    else
      this_recover = recovers
      entity.hp += recovers
    end
    type(effects_message(entity, this_recover))
  end

  def effects_message(entity, recover)
    "#{entity.name} uses #{name} and recovers #{recover}"\
    " HP!\n\nHP: #{entity.hp}/#{entity.max_hp}"
  end

  # The amount of HP that the food recovers.
  attr_reader :recovers

end
