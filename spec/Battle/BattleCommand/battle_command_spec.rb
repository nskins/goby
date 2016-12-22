require_relative '../../../lib/Battle/BattleCommand/battle_command.rb'

RSpec.describe BattleCommand do

  context "constructor" do
    it "has the correct default parameters" do
      cmd = BattleCommand.new
      expect(cmd.name).to eq "BattleCommand"
      expect(cmd.description).to eq nil
    end

    it "correctly assigns custom parameters" do
      dance = BattleCommand.new(name: "Dance",
                                description: "Sway the hips.")
      expect(dance.name).to eq "Dance"
      expect(dance.description).to eq "Sway the hips."
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
  
  context "fails?" do
    it "returns false for the trivial case" do
      entity = Entity.new
      command = BattleCommand.new
      expect(command.fails?(entity)).to be false
    end
  end

  context "to_s" do
    it "returns the name of the BattleCommand" do
      cmd = BattleCommand.new
      expect(cmd.to_s).to eq cmd.name
    end
  end

end
