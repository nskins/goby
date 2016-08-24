require_relative '../../src/Entity/player.rb'
require_relative '../../src/Map/Map/donut_field.rb'

RSpec.describe Player do

  before(:all) do
    # Constructs a map in the shape of a plus sign.
    @map = Map.new(tiles: [ [ Tile.new(passable: false), Tile.new, Tile.new(passable: false) ],
                            [ Tile.new, Tile.new, Tile.new ],
                            [ Tile.new(passable: false), Tile.new, Tile.new(passable: false) ] ],
                   regen_location: Couple.new(1,1))
    @center = @map.regen_location
  end

  before(:each) do
    @dude = Player.new(map: @map, location: @center)
  end

  context "constructor" do
    it "has the correct default parameters" do
      player = Player.new
      expect(player.name).to eq "Player"
      expect(player.max_hp).to eq 100
      expect(player.hp).to eq 100
      expect(player.attack). to eq 15
      expect(player.defense).to eq 1
      expect(player.inventory).to eq Array.new
      expect(player.gold).to eq 0
      expect(player.outfit).to eq Hash.new
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
                        outfit: { weapon: Weapon.new(
                                    attack: Attack.new,
                                    stat_change: StatChange.new(
                                        attack: 3, defense: 1)),
                                  helmet: Helmet.new(
                                      stat_change: StatChange.new(
                                              attack: 1, defense: 5)) },
                        battle_commands: [BattleCommand.new(name: "Yell")],
                        escaped: true,
                        map: Map.new,
                        location: Couple.new(1,1))
      expect(hero.name).to eq "Hero"
      expect(hero.max_hp).to eq 50
      expect(hero.hp).to eq 35
      expect(hero.attack).to eq 16
      expect(hero.defense).to eq 10
      expect(hero.inventory).to eq [Item.new]
      expect(hero.gold).to eq 10
      expect(hero.outfit[:weapon]).to eq Weapon.new
      expect(hero.outfit[:helmet]).to eq Helmet.new
      expect(hero.battle_commands).to eq [Attack.new, BattleCommand.new(name: "Yell")]
      # cannot be overwritten.
      expect(hero.escaped).to eq false
      expect(hero.map).to eq Map.new
      expect(hero.location).to eq Couple.new(1,1)
    end
  end

  context "move to" do
    it "correctly moves the player to a passable tile" do
      @dude.move_to(Couple.new(2,1))
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq Couple.new(2,1)
    end

    it "prevents the player from moving on an impassable tile" do
      @dude.move_to(Couple.new(2,2))
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq @center
    end

    it "prevents the player from moving on a nonexistent tile" do
      @dude.move_to(Couple.new(3,3))
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq @center
    end
  end

  context "move north" do
    it "correctly moves the player to a passable tile" do
      @dude.move_north
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq Couple.new(0,1)
    end

    it "prevents the player from moving on a nonexistent tile" do
      @dude.move_north; @dude.move_north
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq Couple.new(0,1)
    end
  end

  context "move east" do
    it "correctly moves the player to a passable tile" do
      @dude.move_east
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq Couple.new(1,2)
    end

    it "prevents the player from moving on a nonexistent tile" do
      @dude.move_east; @dude.move_east
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq Couple.new(1,2)
    end
  end

  context "move south" do
    it "correctly moves the player to a passable tile" do
      @dude.move_south
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq Couple.new(2,1)
    end

    it "prevents the player from moving on a nonexistent tile" do
      @dude.move_south; @dude.move_south
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq Couple.new(2,1)
    end
  end

  context "move west" do
    it "correctly moves the player to a passable tile" do
      @dude.move_west
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq Couple.new(1,0)
    end

    it "prevents the player from moving on a nonexistent tile" do
      @dude.move_west; @dude.move_west
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq Couple.new(1,0)
    end
  end

end
