require 'goby'

RSpec.describe Monster do
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
                        inventory: [Couple[Item.new, 1]],
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
                        treasures: [Couple[Item.new, 1],
                                    Couple[nil, 3]])
      expect(clown.name).to eq "Clown"
      expect(clown.stats[:max_hp]).to eq 20
      expect(clown.stats[:hp]).to eq 15
      expect(clown.stats[:attack]).to eq 6
      expect(clown.stats[:defense]).to eq 8
      expect(clown.stats[:agility]).to eq 4
      expect(clown.inventory).to eq [Couple[Item.new, 1]]
      expect(clown.gold).to eq 10
      expect(clown.outfit[:weapon]).to eq Weapon.new
      expect(clown.outfit[:helmet]).to eq Helmet.new
      expect(clown.battle_commands).to eq [
        Attack.new,
        Attack.new(name: "Kick"),
        Attack.new(name: "Scratch")
      ]
      expect(clown.message).to eq "\"Oh, hi.\""
      expect(clown.treasures).to eq [Couple[Item.new, 1],
                                     Couple[nil, 3]]
      expect(clown.total_treasures).to eq 4
    end
  end

  context "clone" do
    before(:each) do
      @monster = Monster.new(inventory: [Couple[Item.new, 1]])
      @clone = @monster.clone
    end

    it "should leave the original's inventory the same" do
      @clone.use_item("Item", @clone)
      expect(@monster.inventory.size).to eq 1
      expect(@clone.inventory.size).to be_zero
    end

    it "should leave the clone's inventory the same" do
      @monster.use_item("Item", @monster)
      expect(@monster.inventory.size).to be_zero
      expect(@clone.inventory.size).to eq 1
    end
  end

end
