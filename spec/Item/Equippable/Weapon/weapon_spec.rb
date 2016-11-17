require_relative '../../../../lib/Item/Equippable/Weapon/weapon.rb'

RSpec.describe Weapon do

  context "constructor" do
    it "has the correct default parameters" do
      weapon = Weapon.new
      expect(weapon.name).to eq "Weapon"
      expect(weapon.price).to eq 0
      expect(weapon.consumable).to eq false
      expect(weapon.type).to eq :weapon
    end

    it "correctly assigns custom parameters" do
      pencil = Weapon.new(name: "Pencil",
                           price: 20,
                           consumable: true,
                           stat_change: {attack: 2, defense: 2},
                           type: :helmet)
      expect(pencil.name).to eq "Pencil"
      expect(pencil.price).to eq 20
      expect(pencil.consumable).to eq true
      expect(pencil.stat_change[:attack]).to eq 2
      expect(pencil.stat_change[:defense]).to eq 2
      # Cannot be overwritten.
      expect(pencil.type).to eq :weapon
    end
  end

end
