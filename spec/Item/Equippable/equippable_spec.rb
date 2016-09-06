require_relative '../../../lib/Item/Equippable/equippable.rb'

RSpec.describe Equippable do

  context "constructor" do
    it "has the correct default parameters" do
      equ = Equippable.new
      expect(equ.name).to eq "Equippable"
      expect(equ.price).to eq 0
      expect(equ.consumable).to eq false
      expect(equ.stat_change).to eq StatChange.new({})
      expect(equ.type).to eq :equippable
    end

    it "correctly assigns custom parameters" do
      big_hat = Equippable.new(name: "Big Hat",
                               price: 20,
                               consumable: true,
                               stat_change: StatChange.new(attack: 2,
                                                           defense: 2),
                               type: :weapon)
      expect(big_hat.name).to eq "Big Hat"
      expect(big_hat.price).to eq 20
      expect(big_hat.consumable).to eq true
      expect(big_hat.stat_change).to eq StatChange.new(attack: 2,
                                                       defense: 2)
      # Cannot be overwritten.
      expect(big_hat.type).to eq :equippable
    end
  end

  context "alter stats" do
    it "changes the entity's stats in the trivial case" do
      entity = Entity.new
      equ = Equippable.new(stat_change: StatChange.new(attack: 2,
                                                       defense: 2))
      alter_stats(equ, entity, true)
      expect(entity.attack).to eq 3
      expect(entity.defense).to eq 3

      alter_stats(equ, entity, false)
      expect(entity.attack).to eq 1
      expect(entity.defense).to eq 1
    end
  end

end
