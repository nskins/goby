require_relative '../../../lib/Item/Equippable/equippable.rb'

RSpec.describe Equippable do

  context "constructor" do
    it "has the correct default parameters" do
      equ = Equippable.new
      expect(equ.name).to eq "Equippable"
      expect(equ.price).to eq 0
      expect(equ.consumable).to eq false
      expect(equ.type).to eq :equippable
    end

    it "correctly assigns custom parameters" do
      big_hat = Equippable.new(name: "Big Hat",
                               price: 20,
                               consumable: true,
                               stat_change: {attack: 2, defense: 2, agility: 2},
                               type: :weapon)
      expect(big_hat.name).to eq "Big Hat"
      expect(big_hat.price).to eq 20
      expect(big_hat.consumable).to eq true
      expect(big_hat.stat_change[:attack]).to eq 2
      expect(big_hat.stat_change[:defense]).to eq 2
      expect(big_hat.stat_change[:agility]).to eq 2
      # Cannot be overwritten.
      expect(big_hat.type).to eq :equippable
    end
  end

  context "alter stats" do
    it "changes the entity's stats in the trivial case" do
      entity = Entity.new
      equ = Equippable.new(stat_change: {attack: 2, defense: 3, agility: 4})
      equ.alter_stats(entity, true)
      expect(entity.attack).to eq 3
      expect(entity.defense).to eq 4
      expect(entity.agility).to eq 5
      
      equ.alter_stats(entity, false)
      expect(entity.attack).to eq 1
      expect(entity.defense).to eq 1
      expect(entity.agility).to eq 1
    end
  end

end
