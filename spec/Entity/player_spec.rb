require_relative '../../lib/Entity/player.rb'

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
      expect(player.max_hp).to eq 1
      expect(player.hp).to eq 1
      expect(player.attack). to eq 1
      expect(player.defense).to eq 1
      expect(player.agility).to eq 1
      expect(player.inventory).to eq Array.new
      expect(player.gold).to eq 0
      expect(player.outfit).to eq Hash.new
      expect(player.battle_commands).to eq Array.new
      expect(player.escaped).to eq false
      expect(player.map).to eq Player::DEFAULT_MAP
      expect(player.location).to eq Player::DEFAULT_LOCATION
    end

    it "correctly assigns custom parameters" do
      hero = Player.new(name: "Hero",
                        max_hp: 50,
                        hp: 35,
                        attack: 12,
                        defense: 4,
                        agility: 9,
                        inventory: [Couple.new(Item.new, 1)],
                        gold: 10,
                        outfit: { weapon: Weapon.new(
                                    attack: Attack.new,
                                    stat_change: { attack: 3, defense: 1 }),
                                  helmet: Helmet.new(
                                      stat_change: {attack: 1, defense: 5 }) },
                        battle_commands: [
                          BattleCommand.new(name: "Yell"),
                          BattleCommand.new(name: "Run")
                        ],
                        map: @map,
                        location: Couple.new(1,1))
      expect(hero.name).to eq "Hero"
      expect(hero.max_hp).to eq 50
      expect(hero.hp).to eq 35
      expect(hero.attack).to eq 16
      expect(hero.defense).to eq 10
      expect(hero.agility).to eq 9
      expect(hero.inventory).to eq [Couple.new(Item.new, 1)]
      expect(hero.gold).to eq 10
      expect(hero.outfit[:weapon]).to eq Weapon.new
      expect(hero.outfit[:helmet]).to eq Helmet.new
      expect(hero.battle_commands).to eq [
        Attack.new,
        BattleCommand.new(name: "Run"),
        BattleCommand.new(name: "Yell")
      ]
      # cannot be overwritten.
      expect(hero.escaped).to eq false
      expect(hero.map).to eq @map
      expect(hero.location).to eq Couple.new(1,1)
    end

    context "places the player in the default map & location" do
      it "receives the nil map" do
        player = Player.new(location: Couple.new(2,4))
        expect(player.map).to eq Player::DEFAULT_MAP
        expect(player.location).to eq Player::DEFAULT_LOCATION
      end

      it "receives the nil location" do
        player = Player.new(map: Map.new)
        expect(player.map).to eq Player::DEFAULT_MAP
        expect(player.location).to eq Player::DEFAULT_LOCATION
      end

      it "receives an out-of-bounds location" do
        player = Player.new(map: Map.new, location: Couple.new(0,1))
        expect(player.map).to eq Player::DEFAULT_MAP
        expect(player.location).to eq Player::DEFAULT_LOCATION
      end

      it "receives an impassable location" do
        player = Player.new(map: Map.new(tiles: [ [ Tile.new(passable: false) ] ]),
                            location: Couple.new(0,0))
        expect(player.map).to eq Player::DEFAULT_MAP
        expect(player.location).to eq Player::DEFAULT_LOCATION
      end
    end

  end
  
  context "choose attack" do
    it "should choose the correct attack based on the input" do
      charge = BattleCommand.new(name: "Charge")
      zap = BattleCommand.new(name: "Zap")
      player = Player.new(battle_commands: [charge, zap])
      
      # RSpec input example. Also see spec_helper.rb for __stdin method.
      __stdin("kick\n", "zap\n") do
        expect(player.choose_attack.name).to eq "Zap"
      end
    end
  end    

  context "choose item and on whom" do
    # Define some common variables for these tests.
    before(:all) do
      banana = Item.new(name: "Banana")
      axe = Item.new(name: "Axe")
      @entity = Player.new(inventory: [Couple.new(banana, 1),
                                      Couple.new(axe, 3)])
      @enemy = Entity.new(name: "Enemy")
    end
    
    it "should return correct values based on the input" do  
      # RSpec input example. Also see spec_helper.rb for __stdin method.
      __stdin("goulash\n", "axe\n", "bill\n", "enemy\n") do
        pair = @entity.choose_item_and_on_whom(@enemy)
        expect(pair.first.name).to eq "Axe"
        expect(pair.second.name).to eq "Enemy"
      end
    end
    
    context "should return nil on appropriate input" do
      it "for item" do
        # RSpec input example. Also see spec_helper.rb for __stdin method.
        __stdin("goulash\n", "pass\n") do
          pair = @entity.choose_item_and_on_whom(@enemy)
          expect(pair).to be_nil
        end
      end
      
      it "for whom" do
        # RSpec input example. Also see spec_helper.rb for __stdin method.
        __stdin("banana\n", "bill\n", "pass\n") do
          pair = @entity.choose_item_and_on_whom(@enemy)
          expect(pair).to be_nil
        end
      end
    end
  end
  
  context "die" do
    it "moves the player back to the map's regen location" do
      @dude.move_down
      expect(@dude.location).to eq Couple.new(2,1)
      @dude.die
      expect(@dude.location).to eq @map.regen_location
    end
    
    it "reduces the player's gold by half" do
      @dude.gold = 10
      @dude.die
      expect(@dude.gold).to eq 5
    end
    
    it "recovers the player's HP to max" do
      @dude.hp = 0
      @dude.die
      expect(@dude.hp).to eq @dude.max_hp
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

  context "move up" do
    it "correctly moves the player to a passable tile" do
      @dude.move_up
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq Couple.new(0,1)
    end

    it "prevents the player from moving on a nonexistent tile" do
      @dude.move_up; @dude.move_up
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq Couple.new(0,1)
    end
  end

  context "move right" do
    it "correctly moves the player to a passable tile" do
      @dude.move_right
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq Couple.new(1,2)
    end

    it "prevents the player from moving on a nonexistent tile" do
      @dude.move_right; @dude.move_right
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq Couple.new(1,2)
    end
  end

  context "move down" do
    it "correctly moves the player to a passable tile" do
      @dude.move_down
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq Couple.new(2,1)
    end

    it "prevents the player from moving on a nonexistent tile" do
      @dude.move_down; @dude.move_down
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq Couple.new(2,1)
    end
  end

  context "move left" do
    it "correctly moves the player to a passable tile" do
      @dude.move_left
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq Couple.new(1,0)
    end

    it "prevents the player from moving on a nonexistent tile" do
      @dude.move_left; @dude.move_left
      expect(@dude.map).to eq @map
      expect(@dude.location).to eq Couple.new(1,0)
    end
  end
	
  context "update map" do
    before(:each) do
      @line_map = Map.new(tiles: [ [ Tile.new, Tile.new, Tile.new, Tile.new ] ])
      @player = Player.new(map: @line_map, location: Couple.new(0, 0))
    end

    it "uses default argument to update tiles" do
      @player.update_map
      expect(@line_map.tiles[0][3].seen).to eq false
    end

    it "uses given argument to update tiles" do
      @player.update_map(Couple.new(0, 2))
      expect(@line_map.tiles[0][3].seen).to eq true
    end
  end

end
