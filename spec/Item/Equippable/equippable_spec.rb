require_relative '../../../lib/Item/Equippable/equippable.rb'

RSpec.describe Equippable do

  before do
    @equippable = double
    class << @equippable
      include Equippable
    end
  end

  context "placeholder methods" do
    it "forces :stat_change to be implemented" do
      expect {@equippable.stat_change}.to raise_error(NotImplementedError, 'An Equippable Item must implement a stat_change Hash')
    end

    it "forces :type to be implemented" do
      expect {@equippable.type}. to raise_error(NotImplementedError, 'An Equippable Item must have a type')
    end
  end

  context "alter stats" do
    it "changes the entity's stats in the trivial case" do
      entity = Entity.new
      allow(@equippable).to receive(:stat_change) {{attack: 2, defense: 3, agility: 4}}

      @equippable.alter_stats(entity, true)
      expect(entity.attack).to eq 3
      expect(entity.defense).to eq 4
      expect(entity.agility).to eq 5
 
      @equippable.alter_stats(entity, false)
      expect(entity.attack).to eq 1
      expect(entity.defense).to eq 1
      expect(entity.agility).to eq 1
    end
  end

end
