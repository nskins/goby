require 'goby'

RSpec.describe Monster do

  # let!(:wolf) {
  #   Monster.new(name: "Wolf",
  #                       stats: { max_hp: 20,
  #                                hp: 15,
  #                                attack: 2,
  #                                defense: 2,
  #                                agility: 4 },
  #                       inventory: [C[Item.new, 1]],
  #                       gold: 10,
  #                       outfit: { weapon: Weapon.new(
  #                           attack: Attack.new,
  #                           stat_change: {attack: 3, defense: 1}
  #                       ),
  #                                 helmet: Helmet.new(
  #                                     stat_change: {attack: 1, defense: 5}
  #                                 )
  #                       },
  #                       battle_commands: [
  #                           Attack.new(name: "Scratch"),
  #                           Attack.new(name: "Kick")
  #                       ],
  #                       message: "\"Oh, hi.\"",
  #                       treasures: [C[Item.new, 1],
  #                                   C[nil, 3]])
  # }
  # let!(:dude) { Player.new(stats: { attack: 10, agility: 10000 },
  #                          battle_commands: [Attack.new(strength: 20), Escape.new, Use.new],
  #                          map: map, location: center) }
  # let!(:slime) { Monster.new(battle_commands: [Attack.new(success_rate: 0)],
  #                            gold: 5000, treasures: [C[Item.new, 1]]) }
  # let!(:newb) { Player.new(battle_commands: [Attack.new(success_rate: 0)],
  #                          gold: 50, map: map, location: center) }

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
      expect(monster.message).to eq "!!!"
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
                        message: "\"Oh, hi.\"",
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
      expect(clown.message).to eq "\"Oh, hi.\""
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

  # context "fighter" do
  #   it "should be a fighter" do
  #     expect(wolf.fighter?).to be true
  #   end
  # end

  # context "battle" do
  #   it "should allow the player to win in this example" do
  #     __stdin("attack\n") do
  #       dude.battle(slime)
  #     end
  #     expect(dude.inventory.size).to eq 1
  #   end
  #
  #   it "should allow the player to escape in this example" do
  #     # Could theoretically fail, but with very low probability.
  #     __stdin("escape\nescape\nescape\n") do
  #       dude.battle(slime)
  #     end
  #   end
  #
  #   it "should allow the monster to win in this example" do
  #     __stdin("attack\n") do
  #       newb.battle(dragon)
  #     end
  #     # Newb should die and go to respawn location.
  #     expect(newb.gold).to eq 25
  #     expect(newb.location).to eq C[1,1]
  #   end
  # end

end
