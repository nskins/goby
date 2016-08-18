require_relative '../equippable.rb'

class Helmet < Equippable

  def initialize(params = {})
    super(params)
    @name = params[:name] || "Helmet"
  end

  def unequip(entity)
    entity.helmet = nil
    restore_status(self, entity)
  end

  def use(entity)
    prev_helmet = entity.helmet
    entity.helmet = self
    equip(entity, prev_helmet)
  end

end
