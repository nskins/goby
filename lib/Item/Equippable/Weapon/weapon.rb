require_relative '../equippable.rb'
require_relative '../../../Battle/BattleCommand/Attack/attack.rb'

class Weapon < Equippable

  # @param [String] name the name.
  # @param [Integer] price the cost in a shop.
  # @param [Boolean] consumable determines whether the item is lost when used.
  # @param [Boolean] disposable allowed to sell or drop item when true.
  # @param [Hash] stat_change the change in stats for when the item is equipped.
  # @param [Attack] attack the attack which is added to the entity's battle commands.
  def initialize(name: "Weapon", price: 0, consumable: false, disposable: true, stat_change: {}, attack: nil)
    super(name: name, price: price, consumable: consumable, disposable: disposable, stat_change: stat_change)
    @attack = attack
    @type = :weapon
  end

  # Equips onto the entity and changes the entity's attributes accordingly.
  #
  # @param [Entity] entity the entity who is equipping the equippable.
  def equip(entity)
    prev_weapon = nil
    if entity.outfit[@type]
      prev_weapon = entity.outfit[@type]
    end

    super(entity)

    if (prev_weapon && prev_weapon.attack)
      entity.remove_battle_command(prev_weapon.attack)
    end

    if @attack
      entity.add_battle_command(@attack)
    end

  end

  # Unequips from the entity and changes the entity's attributes accordingly.
  #
  # @param [Entity] entity the entity who is unequipping the equippable.
  def unequip(entity)
    super(entity)

    if @attack
      entity.remove_battle_command(@attack)
    end

  end

  # An instance of Attack.
  attr_accessor :attack

end
