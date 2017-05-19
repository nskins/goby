require 'goby'

RSpec.describe Goby::BattleCommand do

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

  context "run" do
    it "prints the default message" do
      user = Entity.new
      enemy = Entity.new
      cmd = BattleCommand.new
      # Rspec: expect output.
      expect { cmd.run(user, enemy) }.to output(Goby::BattleCommand::NO_ACTION).to_stdout
    end
  end

  context "fails?" do
    it "returns false for the trivial case" do
      entity = Entity.new
      command = BattleCommand.new
      expect(command.fails?(entity)).to be false
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

  context "to_s" do
    it "returns the name of the BattleCommand" do
      cmd = BattleCommand.new
      expect(cmd.to_s).to eq cmd.name
    end
  end

end
