require_relative '../../../lib/Entity/Monster/monster.rb'

RSpec.describe Monster do
  context "constructor" do
    it "has the correct default parameters" do
      monster = Monster.new
      expect(monster.name).to eq "Monster"
      expect(monster.max_hp).to eq 1
      expect(monster.hp).to eq 1
      expect(monster.attack). to eq 1
      expect(monster.defense).to eq 1
      expect(monster.agility).to eq 1
      expect(monster.inventory).to eq Array.new
      expect(monster.gold).to eq 0
      expect(monster.outfit).to eq Hash.new
      expect(monster.battle_commands).to eq Array.new
      expect(monster.escaped).to eq false
      expect(monster.message).to eq "!!!"
    end

    it "correctly assigns custom parameters" do
      clown = Monster.new(name: "Clown",
                        max_hp: 20,
                        hp: 15,
                        attack: 2,
                        defense: 2,
                        agility: 4,
                        inventory: [Couple.new(Item.new, 1)],
                        gold: 10,
                        outfit: { weapon: Weapon.new(
                                    attack: Attack.new,
                                    stat_change: {attack: 3, defense: 1}
                                  ),
                                  helmet: Helmet.new(
                                      stat_change: {attack: 1, defense: 5}
                                  )
                                },
                        battle_commands: [
                          Attack.new(name: "Scratch"),
                          Attack.new(name: "Kick")
                        ],
                        escaped: true,
                        message: "\"Oh, hi.\"")
      expect(clown.name).to eq "Clown"
      expect(clown.max_hp).to eq 20
      expect(clown.hp).to eq 15
      expect(clown.attack).to eq 6
      expect(clown.defense).to eq 8
      expect(clown.agility).to eq 4
      expect(clown.inventory).to eq [Couple.new(Item.new, 1)]
      expect(clown.gold).to eq 10
      expect(clown.outfit[:weapon]).to eq Weapon.new
      expect(clown.outfit[:helmet]).to eq Helmet.new
      expect(clown.battle_commands).to eq [
        Attack.new,
        Attack.new(name: "Kick"),
        Attack.new(name: "Scratch")
      ]
      # cannot be overwritten.
      expect(clown.escaped).to eq false
      expect(clown.message).to eq "\"Oh, hi.\""
    end
  end

end
