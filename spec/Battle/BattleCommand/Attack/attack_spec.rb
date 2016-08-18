require_relative '../../../../src/Battle/BattleCommand/Attack/attack.rb'

RSpec.describe Attack do
  
  context "constructor" do
    it "has the correct default parameters" do
      attack = Attack.new
      expect(attack.name).to eq "Attack"
      expect(attack.damage).to eq 0
      expect(attack.success_rate).to eq 100
      expect(attack.weapon_attack).to eq false
    end

    it "correctly assigns custom parameters" do
      poke = Attack.new(name: "Poke",
                        damage: 12,
                        success_rate: 95,
                        weapon_attack: true)
      expect(poke.name).to eq "Poke"
      expect(poke.damage).to eq 12
      expect(poke.success_rate).to eq 95
      expect(poke.weapon_attack).to eq true
    end
  end

  context "equality operator" do
    it "returns true for the seemingly trivial case" do
      expect(Attack.new).to eq Attack.new
    end

    it "returns false for commands with different names" do
      poke = Attack.new(name: "Poke")
      kick = Attack.new(name: "Kick")
      expect(poke).not_to eq kick
    end
  end

end
