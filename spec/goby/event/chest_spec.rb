require 'goby'

RSpec.describe Chest do

  before(:each) do
    @player = Player.new
    @chest = Chest.new
    @gold_chest = Chest.new(gold: 100)
    @treasure_chest = Chest.new(treasures: [Item.new, Food.new, Helmet.new])
    @giant_chest = Chest.new(gold: 100, treasures: [Item.new, Food.new, Helmet.new])
  end

  context "constructor" do
    it "has the correct default parameters" do
      expect(@chest.mode).to be_zero
      expect(@chest.visible).to be true
      expect(@chest.gold).to be_zero
      expect(@chest.treasures).to be_empty
    end

    it "correctly assigns custom parameters" do
      chest = Chest.new(mode: 5, visible: false, gold: 3, treasures: [Item.new])
      expect(chest.mode).to eq 5
      expect(chest.visible).to be false
      expect(chest.gold).to be 3
      expect(chest.treasures[0]).to eq Item.new
    end
  end

  context "run" do
    it "should no longer be visible after the first open" do
      @chest.run(@player)
      expect(@chest.visible).to be false
    end

    it "correctly gives the player nothing for no gold, no treasure" do
      @chest.run(@player)
      expect(@player.gold).to be_zero
      expect(@player.inventory).to be_empty
    end

    it "correctly gives the player only gold when no treasure" do
      @gold_chest.run(@player)
      expect(@player.gold).to be 100
      expect(@player.inventory).to be_empty
    end

    it "correctly gives the player only treasure when no gold" do
      @treasure_chest.run(@player)
      expect(@player.gold).to be_zero
      expect(@player.inventory.size).to be 3
    end

    it "correctly gives the player both gold and treasure when both" do
      @giant_chest.run(@player)
      expect(@player.gold).to be 100
      expect(@player.inventory.size).to be 3
    end

    it "outputs that there is no loot for no gold, no treasure" do
      expect { @chest.run(@player) }.to output(
        "You open the treasure chest...\n\nLoot: nothing!\n\n"
      ).to_stdout
    end

    it "outputs that there is only gold when no treasure" do
      expect { @gold_chest.run(@player) }.to output(
        "You open the treasure chest...\n\nLoot: \n* 100 gold\n\n"
      ).to_stdout
    end

    it "outputs that there is only treasure when no gold" do
      expect { @treasure_chest.run(@player) }.to output(
        "You open the treasure chest...\n\n"\
        "Loot: \n* Item\n* Food\n* Helmet\n\n"
      ).to_stdout
    end

    it "outputs that there is both treasure and gold when both" do
      expect { @giant_chest.run(@player) }.to output(
        "You open the treasure chest...\n\n"\
        "Loot: \n* 100 gold\n* Item\n* Food\n* Helmet\n\n"
      ).to_stdout
    end
  end

end