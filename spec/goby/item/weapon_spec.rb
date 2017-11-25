require 'goby'

RSpec.describe Weapon do

  let(:weapon) { Weapon.new }
  let(:entity) { Entity.new.extend(Fighter) }
  let(:dummy_fighter_class) { Class.new(Entity) {include Fighter} }

  context "constructor" do
    it "has the correct default parameters" do
      expect(weapon.name).to eq "Weapon"
      expect(weapon.price).to eq 0
      expect(weapon.consumable).to eq false
      expect(weapon.disposable).to eq true
      expect(weapon.type).to eq :weapon
    end

    it "correctly assigns custom parameters" do
      pencil = Weapon.new(name: "Pencil",
                          price: 20,
                          consumable: true,
                          disposable: false,
                          stat_change: {attack: 2, defense: 2})
      expect(pencil.name).to eq "Pencil"
      expect(pencil.price).to eq 20
      expect(pencil.consumable).to eq true
      expect(pencil.disposable).to eq false
      expect(pencil.stat_change[:attack]).to eq 2
      expect(pencil.stat_change[:defense]).to eq 2
      # Cannot be overwritten.
      expect(pencil.type).to eq :weapon
    end
  end

  context "equip" do
    it "correctly equips the weapon and alters the stats of a Fighter Entity" do
      weapon = Weapon.new(stat_change: {attack: 3},
                          attack: Attack.new)
      weapon.equip(entity)
      expect(entity.outfit[:weapon]).to eq Weapon.new
      expect(entity.stats[:attack]).to eq 4
      expect(entity.battle_commands).to eq [Attack.new]
    end
  end

  context "use" do
    it "should print an appropriate message for how to equip" do
      expect { weapon.use(entity, entity) }.to output(
                                                   "Type 'equip Weapon' to equip this item.\n\n"
                                               ).to_stdout
    end
  end

  context "unequip" do
    it "correctly unequips an equipped item from a Fighter Entity" do
      weapon = Weapon.new(stat_change: {agility: 4},
                          attack: Attack.new)
      entity = dummy_fighter_class.new(outfit: {weapon: weapon})

      weapon.unequip(entity)
      expect(entity.outfit).to be_empty
      expect(entity.battle_commands).to be_empty
      expect(entity.stats[:agility]).to eq 1
    end
  end

end
