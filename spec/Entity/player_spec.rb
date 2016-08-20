require_relative '../../src/Entity/player.rb'
require_relative '../../src/Map/Map/donut_field.rb'

RSpec.describe Player do

  context "constructor" do
    it "has the correct default parameters" do
      player = Player.new
      expect(player.name).to eq "Player"
      expect(player.max_hp).to eq 100
      expect(player.hp).to eq 100
      expect(player.attack). to eq 15
      expect(player.defense).to eq 1
      expect(player.inventory).to eq []
      expect(player.gold).to eq 0
      expect(player.weapon).to eq nil
      expect(player.helmet).to eq nil
      expect(player.battle_commands).to eq [BattleCommand.new(name: "Escape"),
                                            BattleCommand.new(name: "Kick")]
      expect(player.escaped).to eq false
      expect(player.map).to eq nil
      expect(player.location).to eq nil
    end

    it "correctly assigns custom parameters" do
      hero = Player.new(name: "Hero",
                        max_hp: 50,
                        hp: 35,
                        attack: 12,
                        defense: 4,
                        inventory: [Item.new],
                        gold: 10,
                        weapon: Weapon.new,
                        helmet: Helmet.new,
                        battle_commands: [BattleCommand.new(name: "Yell")],
                        escaped: true,
                        map: Map.new,
                        location: Couple.new(1,1))
      expect(hero.name).to eq "Hero"
      expect(hero.max_hp).to eq 50
      expect(hero.hp).to eq 35
      expect(hero.attack).to eq 12
      expect(hero.defense).to eq 4
      expect(hero.inventory).to eq [Item.new]
      expect(hero.gold).to eq 10
      expect(hero.weapon).to eq Weapon.new
      expect(hero.helmet).to eq Helmet.new
      expect(hero.battle_commands).to eq [BattleCommand.new(name: "Yell")]
      # cannot be overwritten.
      expect(hero.escaped).to eq false
      expect(hero.map).to eq Map.new
      expect(hero.location).to eq Couple.new(1,1)
    end
  end

end
