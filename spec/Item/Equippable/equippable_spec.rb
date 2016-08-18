require_relative '../../../src/Item/Equippable/equippable.rb'

RSpec.describe Equippable do

  context "constructor" do
    it "has the correct default parameters" do
      equ = Equippable.new
      expect(equ.name).to eq "Equippable"
      expect(equ.price).to eq 0
      expect(equ.consumable).to eq true
      expect(equ.stat_change).to eq StatChange.new({})
    end

    it "correctly assigns custom parameters" do
      big_hat = Equippable.new(name: "Big Hat",
                               price: 20,
                               consumable: false,
                               stat_change: StatChange.new(attack: 2,
                                                           defense: 2))
      expect(big_hat.name).to eq "Big Hat"
      expect(big_hat.price).to eq 20
      expect(big_hat.consumable).to eq false
      expect(big_hat.stat_change).to eq StatChange.new(attack: 2,
                                                       defense: 2)
    end
  end

  context "alter stats" do
    it "changes the entity's stats in the trivial case" do
      entity = Entity.new
      equ = Equippable.new(stat_change: StatChange.new(attack: 2,
                                                       defense: 2))
      alter_stats(equ, entity, true)
      expect(entity.attack).to eq 2
      expect(entity.defense).to eq 2

      alter_stats(equ, entity, false)
      expect(entity.attack).to eq 0
      expect(entity.defense).to eq 0
    end

    it "does not lower the entity's attributes below zero" do
      entity = Entity.new(attack: 2, defense: 2)
      equ = Equippable.new(stat_change: StatChange.new(attack: -5,
                                                       defense: -5))
      alter_stats(equ, entity, true)
      expect(entity.attack).to eq 0
      expect(entity.defense).to eq 0

      alter_stats(equ, entity, false)
      expect(entity.attack).to eq 2
      expect(entity.defense).to eq 2
    end
  end

  context "restore status" do
    it "changes the entity's status in the trivial case" do
      entity = Entity.new(attack: 4, defense: 4)
      equ = Equippable.new(stat_change: StatChange.new(attack: 3,
                                                       defense: 3))
      restore_status(equ, entity)
      expect(entity.inventory.length).to eq 1
      expect(entity.attack).to eq 1
      expect(entity.defense).to eq 1
    end
  end

end
