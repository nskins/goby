require_relative '../../../../lib/Battle/BattleCommand/Attack/attack.rb'
require_relative '../../../../lib/Entity/player.rb'
require_relative '../../../../lib/Entity/Monster/monster.rb'

RSpec.describe Attack do

  context "constructor" do
    it "has the correct default parameters" do
      attack = Attack.new
      expect(attack.name).to eq "Attack"
      expect(attack.strength).to eq 1
      expect(attack.success_rate).to eq 100
    end

    it "correctly assigns all custom parameters" do
      poke = Attack.new(name: "Poke",
                        strength: 12,
                        success_rate: 95)
      expect(poke.name).to eq "Poke"
      expect(poke.strength).to eq 12
      expect(poke.success_rate).to eq 95
    end
    
    it "correctly assigns only one custom parameter" do
      attack = Attack.new(success_rate: 77)
      expect(attack.name).to eq "Attack"
      expect(attack.strength).to eq 1
      expect(attack.success_rate).to eq 77
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
  
  context "run" do
    # TODO
  end

  context "calculate damage" do
    it "returns a random value" do
      user = Player.new(name: "Hero",
                        max_hp: 50,
                        hp: 35,
                        attack: 12,
                        defense: 4)

      enemy = Monster.new(max_hp: 30,
                          defense: 2)

      attack = Attack.new(strength: 5)
      damage = attack.calculate_damage(user, enemy)
      enemy.hp -= damage
      expect(enemy.hp).to be_within(18).of(23)
    end
  end

end
