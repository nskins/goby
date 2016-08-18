require_relative '../../../src/Battle/BattleCommand/battle_command.rb'

RSpec.describe BattleCommand do

  context "constructor" do
    it "has the correct default parameters" do
      cmd = BattleCommand.new
      expect(cmd.name).to eq "BattleCommand"
    end

    it "correctly assigns custom parameters" do
      dance = BattleCommand.new(name: "Dance")
      expect(dance.name).to eq "Dance"
    end
  end

  context "equality operator" do
    it "returns true for the seemingly trivial case" do
      expect(BattleCommand.new).to eq BattleCommand.new
    end

    it "returns false for commands with different names" do
      dance = BattleCommand.new(name: "Dance")
      kick = BattleCommand.new(name: "Kick")
      expect(dance).not_to eq kick
    end
  end
end
