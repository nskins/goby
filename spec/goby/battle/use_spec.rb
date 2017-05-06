require 'goby'

RSpec.describe Use do

  before(:all) do
    @use = Use.new
  end

  context "constructor" do
    it "has an appropriate default name" do
      expect(@use.name).to eq "Use"
    end
  end

  context "run" do
    before(:each) do
      @player = Player.new(max_hp: 10, hp: 3, battle_commands: [@use],
                           inventory: [Couple.new(Food.new(recovers: 5), 1)])
      @monster = Monster.new
    end

    it "uses the specified item and remove it from the entity's inventory" do
      # RSpec input example. Also see spec_helper.rb for __stdin method.
      __stdin("food\n", "player\n") do
        @use.run(@player, @monster)
        expect(@player.hp).to eq 8
        expect(@player.inventory.empty?).to be true
      end
    end

    it "has no effect when the user chooses to pass" do
      __stdin("pass\n") do
        @use.run(@player, @monster)
        expect(@player.inventory.empty?).to be false
      end
    end
  end

  context "fails?" do
    before(:each) do
      @entity = Entity.new
    end

    it "returns true when the user's inventory is empty" do
      expect(@use.fails?(@entity)).to be true
    end

    it "returns false when the user has at least one item" do
      @entity.add_item(Item.new)
      expect(@use.fails?(@entity)).to be false
    end
  end

end