require_relative '../../../src/Entity/Monster/monster.rb'

RSpec.describe Monster do
  context "constructor" do
    it "has the correct default parameters" do
      monster = Monster.new
      expect(monster.name).to eq "Monster"
      expect(monster.max_hp).to eq 0
      expect(monster.hp).to eq 0
      expect(monster.attack). to eq 0
      expect(monster.defense).to eq 0
      expect(monster.inventory).to eq []
      expect(monster.gold).to eq 0
      expect(monster.weapon).to eq nil
      expect(monster.helmet).to eq nil
      expect(monster.battle_commands).to eq []
      expect(monster.escaped).to eq false
      expect(monster.visible).to eq true
      expect(monster.regen).to eq true
      expect(monster.message).to eq "!!!"
    end

    it "correctly assigns custom parameters" do
      clown = Monster.new(name: "Clown",
                        max_hp: 20,
                        hp: 15,
                        attack: 2,
                        defense: 2,
                        inventory: [Item.new],
                        gold: 10,
                        weapon: Weapon.new,
                        helmet: Helmet.new,
                        battle_commands: [Attack.new(name: "Kick")],
                        escaped: true,
                        visible: false,
                        regen: false,
                        message: "\"Oh, hi.\"")
      expect(clown.name).to eq "Clown"
      expect(clown.max_hp).to eq 20
      expect(clown.hp).to eq 15
      expect(clown.attack).to eq 2
      expect(clown.defense).to eq 2
      expect(clown.inventory).to eq [Item.new]
      expect(clown.gold).to eq 10
      expect(clown.weapon).to eq Weapon.new
      expect(clown.helmet).to eq Helmet.new
      expect(clown.battle_commands).to eq [Attack.new(name: "Kick")]
      # cannot be overwritten.
      expect(clown.escaped).to eq false
      expect(clown.visible).to eq false
      expect(clown.regen).to eq false
      expect(clown.message).to eq "\"Oh, hi.\""
    end
  end

end
