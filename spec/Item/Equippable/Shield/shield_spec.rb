require_relative '../../../../lib/Item/Equippable/Shield/shield.rb'

RSpec.describe Shield do

  context "constructor" do
    it "has the correct default parameters" do
      shield = Shield.new
      expect(shield.name).to eq "Shield"
      expect(shield.price).to eq 0
      expect(shield.consumable).to eq false
      expect(shield.type).to eq :shield
    end

    it "correctly assigns custom parameters" do
      buckler = Shield.new(name: "Buckler",
                           price: 20,
                           consumable: true,
                           stat_change: {attack: 2, defense: 2},
                           type: :helmet)
      expect(buckler.name).to eq "Buckler"
      expect(buckler.price).to eq 20
      expect(buckler.consumable).to eq true
      expect(buckler.stat_change[:attack]).to eq 2
      expect(buckler.stat_change[:defense]).to eq 2
      # Cannot be overwritten.
      expect(buckler.type).to eq :shield
    end
  end

end
