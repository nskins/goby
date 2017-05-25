require 'goby'

RSpec.describe Equippable do

  context "placeholder methods" do

    before (:all) do
      @equippable = double
      class << @equippable
        include Equippable
      end
    end

    it "forces :stat_change to be implemented" do
      expect {@equippable.stat_change}.to raise_error(NotImplementedError, 'An Equippable Item must implement a stat_change Hash')
    end

    it "forces :type to be implemented" do
      expect {@equippable.type}. to raise_error(NotImplementedError, 'An Equippable Item must have a type')
    end
  end

  context "alter stats" do

    before (:each) do
      @equippable = double
      class << @equippable
        include Equippable
      end
      @entity = Entity.new
      allow(@equippable).to receive(:stat_change) { { attack: 2, defense: 3, agility: 4, max_hp: 2 } }
    end

    it "changes the entity's stats in the trivial case" do
      @equippable.alter_stats(@entity, true)
      expect(@entity.stats[:attack]).to eq 3
      expect(@entity.stats[:defense]).to eq 4
      expect(@entity.stats[:agility]).to eq 5
      expect(@entity.stats[:max_hp]).to eq 3
      expect(@entity.stats[:hp]).to eq 1

      @equippable.alter_stats(@entity, false)
      expect(@entity.stats[:attack]).to eq 1
      expect(@entity.stats[:defense]).to eq 1
      expect(@entity.stats[:agility]).to eq 1
      expect(@entity.stats[:max_hp]).to eq 1
      expect(@entity.stats[:hp]).to eq 1
    end

    it "does not lower stats below 1" do
      @equippable.alter_stats(@entity, false)
      expect(@entity.stats[:attack]).to eq 1
      expect(@entity.stats[:defense]).to eq 1
      expect(@entity.stats[:agility]).to eq 1
      expect(@entity.stats[:max_hp]).to eq 1
      expect(@entity.stats[:hp]).to eq 1
    end
  end

end
