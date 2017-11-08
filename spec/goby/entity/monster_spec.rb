require 'goby'

RSpec.describe Monster do

  let(:slime_item) { Item.new }

  let(:wolf) {
    Monster.new(name: "Wolf",
                        stats: { max_hp: 20,
                                 hp: 15,
                                 attack: 2,
                                 defense: 2,
                                 agility: 4 },
                        inventory: [C[Item.new, 1]],
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
                        ])
  }
  let!(:dude) { Player.new(stats: { attack: 10, agility: 10000 },
                           battle_commands: [Attack.new(strength: 20), Escape.new, Use.new])}
  let!(:slime) { Monster.new(battle_commands: [Attack.new(success_rate: 0)],
                             gold: 5000, treasures: [C[slime_item, 1]]) }
  let(:newb) { Player.new(battle_commands: [Attack.new(success_rate: 0)],
                           gold: 50) }

  context "constructor" do
    it "has the correct default parameters" do
      monster = Monster.new
      expect(monster.name).to eq "Monster"
      expect(monster.stats[:max_hp]).to eq 1
      expect(monster.stats[:hp]).to eq 1
      expect(monster.stats[:attack]). to eq 1
      expect(monster.stats[:defense]).to eq 1
      expect(monster.stats[:agility]).to eq 1
      expect(monster.inventory).to eq Array.new
      expect(monster.gold).to eq 0
      expect(monster.outfit).to eq Hash.new
      expect(monster.battle_commands).to eq Array.new
      expect(monster.treasures).to eq Array.new
    end

    it "correctly assigns custom parameters" do
      clown = Monster.new(name: "Clown",
                          stats: { max_hp: 20,
                                   hp: 15,
                                   attack: 2,
                                   defense: 2,
                                   agility: 4 },
                        inventory: [C[Item.new, 1]],
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
                        treasures: [C[Item.new, 1],
                                    C[nil, 3]])
      expect(clown.name).to eq "Clown"
      expect(clown.stats[:max_hp]).to eq 20
      expect(clown.stats[:hp]).to eq 15
      expect(clown.stats[:attack]).to eq 6
      expect(clown.stats[:defense]).to eq 8
      expect(clown.stats[:agility]).to eq 4
      expect(clown.inventory).to eq [C[Item.new, 1]]
      expect(clown.gold).to eq 10
      expect(clown.outfit[:weapon]).to eq Weapon.new
      expect(clown.outfit[:helmet]).to eq Helmet.new
      expect(clown.battle_commands).to eq [
        Attack.new,
        Attack.new(name: "Kick"),
        Attack.new(name: "Scratch")
      ]
      expect(clown.treasures).to eq [C[Item.new, 1],
                                     C[nil, 3]]
      expect(clown.total_treasures).to eq 4
    end
  end

  context "clone" do
    let(:monster) { Monster.new(inventory: [C[Item.new, 1]]) }
    let!(:clone) { monster.clone }

    it "should leave the original's inventory the same" do
      clone.use_item("Item", clone)
      expect(monster.inventory.size).to eq 1
      expect(clone.inventory.size).to be_zero
    end

    it "should leave the clone's inventory the same" do
      monster.use_item("Item", monster)
      expect(monster.inventory.size).to be_zero
      expect(clone.inventory.size).to eq 1
    end
  end

  # Fighter specific specs

  context "fighter" do
    it "should be a fighter" do
      expect(wolf.fighter?).to be true
    end
  end

  context "battle" do
    it "should allow the monster to win in this example" do
      __stdin("attack\n") do
        wolf.battle(newb)
      end
      # The amount of gold the Monster had + that returned by the Player
      expect(wolf.gold).to eq 35
    end


    it "should allow the player to win in this example" do
      __stdin("attack\n") do
        slime.battle(dude)
      end
      expect(dude.inventory.size).to eq 1
    end

    it "should allow the stronger monster to win as the attacker" do
      wolf.battle(slime)
      expect(wolf.inventory.size).to eq 1
    end

    it "should allow the stronger monster to win as the defender" do
      slime.battle(wolf)
      expect(wolf.inventory.size).to eq 1
    end
  end

  context "die" do
    it "does nothing" do
      expect(wolf.die).to be_nil
    end
  end

  context "sample gold" do
    it "returns a random amount of gold" do
      gold_sample = wolf.sample_gold
      expect(gold_sample).to be >= 0
      expect(gold_sample).to be <= 10
    end
  end

  context "sample treasures" do
    it "returns the treasure when there is only one" do
      expect(slime.sample_treasures).to eq slime_item
    end

    it "returns nothing if there are no treasures" do
      expect(wolf.sample_treasures).to be_nil
    end
  end

end
