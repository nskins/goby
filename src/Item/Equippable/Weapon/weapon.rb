require_relative '../equippable.rb'
require_relative '../../../Battle/BattleCommand/Attack/attack.rb'

class Weapon < Equippable

  def initialize(params = {})
    super(params)
    @name = params[:name] || "Weapon"
    @attack = params[:attack] || nil
    @type = :weapon
  end

  def unequip(entity)
    super(entity)
    entity.weapon = nil
    restore_status(self, entity)

    if (!@attack.nil?)
      entity.remove_battle_command(@attack)
    end

  end

  def use(entity)
    prev_weapon = entity.weapon
    entity.weapon = self
    equip(entity, prev_weapon)

    if (!prev_weapon.nil? && prev_weapon.attack.nil?)
      entity.remove_battle_command(prev_weapon.attack)
    end

    if (!self.attack.nil?)
      entity.add_battle_command(self.attack)
    end
  end

  # An instance of Attack.
  attr_accessor :attack

end
