require_relative '../../../lib/Battle/BattleCommand/escape.rb'

RSpec.describe Escape do

  context "constructor" do
    it "has an appropriate default name" do
      escape = Escape.new
      expect(escape.name).to eq "Escape"
    end
  end

  context "run" do
    # The purpose of this test is to run the code without error.
    it "should return a usable result" do
      player = Player.new
      monster = Monster.new
      escape = Escape.new
      escape.run(player, monster)
      expect(player.escaped).to_not be nil
    end
  end

end
