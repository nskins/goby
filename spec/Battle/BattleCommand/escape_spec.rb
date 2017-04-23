require_relative '../../../lib/Battle/BattleCommand/escape.rb'

RSpec.describe Escape do

  before(:all) do
    @player = Player.new
    @monster = Monster.new
    @escape = Escape.new
  end

  context "constructor" do
    it "has an appropriate default name" do
      expect(@escape.name).to eq "Escape"
    end
  end

  context "run" do
    # The purpose of this test is to run the code without error.
    it "should return a usable result" do
      # Exercise both branches of this function w/ high probability.
      20.times do
        @escape.run(@player, @monster)
        expect(@player.escaped).to_not be nil
      end
    end
  end

end
