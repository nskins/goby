require_relative '../equippable.rb'
require_relative '../../../Battle/BattleCommand/Attack/attack.rb'

class Weapon < Equippable

  def initialize(params = {})
    super(params)
    @name = params[:name] || "Weapon"
    @attack = params[:attack] || nil
    @type = :weapon
  end

  def equip(entity)
    prev_weapon = nil
    if (!entity.outfit.nil?)
      prev_weapon = entity.outfit[@type]
    end

    super(entity)

    if (!prev_weapon.nil? && prev_weapon.attack.nil?)
      entity.remove_battle_command(prev_weapon.attack)
    end

    if (!self.attack.nil?)
      entity.add_battle_command(self.attack)
    end

  end

  def unequip(entity)
    super(entity)

    if (!@attack.nil?)
      entity.remove_battle_command(@attack)
    end

  end

  # An instance of Attack.
  attr_accessor :attack

end
