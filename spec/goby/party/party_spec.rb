require 'goby'

RSpec.describe Party do

  before(:all) do
    @liverpool = Map.new(tiles: [ [ Tile.new(passable: false), Tile.new, Tile.new(passable: false) ],
                            [ Tile.new, Tile.new, Tile.new ],
                            [ Tile.new(passable: false), Tile.new, Tile.new(passable: false) ] ],
                         regen_location: Couple.new(1,1))
    @center = @liverpool.regen_location
    @monster_map = Map.new(tiles: [ [ Tile.new(monsters: [Monster.new(battle_commands: [Attack.new(success_rate: 0)]) ]) ] ],
                           regen_location: Couple.new(0,0))
    @passable = Tile::DEFAULT_PASSABLE
    @impassable = Tile::DEFAULT_IMPASSABLE
  end

  before(:each) do
    @party = Party.new
    @beatles = Party.new(members: [Entity.new(name: "John"),
                                   Entity.new(name: "Paul"),
                                   Entity.new(name: "George"),
                                   Entity.new(name: "Ringo")],
                         gold: 8,
                         inventory: [Couple.new(Item.new, 1)],
                         map: @liverpool,
                         location: @liverpool.regen_location)
  end

  context "constructor" do
    it "has the correct default constructors" do
      expect(@party.members).to eq []
      expect(@party.map).to eq Party::DEFAULT_MAP
      expect(@party.location).to eq Party::DEFAULT_LOCATION
      expect(@party.gold).to be_zero
      expect(@party.inventory).to be_empty
    end

    it "correctly assigns custom parameters" do
      expect(@beatles.members.size).to eq 4
      expect(@beatles.map).to eq @liverpool
      expect(@beatles.location).to eq Couple.new(1,1)
    end

    it "throws an error when there are two members with the same name" do
      expect {Party.new(members: [Entity.new, Entity.new])}.to raise_error
    end

    context "places the party in the default map & location" do
      it "receives the nil map" do
        party = Party.new(location: Couple.new(2,4))
        expect(party.map).to eq Party::DEFAULT_MAP
        expect(party.location).to eq Party::DEFAULT_LOCATION
      end

      it "receives the nil location" do
        party = Party.new(map: Map.new)
        expect(party.map).to eq Party::DEFAULT_MAP
        expect(party.location).to eq Party::DEFAULT_LOCATION
      end

      it "receives an out-of-bounds location" do
        party = Party.new(map: Map.new, location: Couple.new(0,1))
        expect(party.map).to eq Party::DEFAULT_MAP
        expect(party.location).to eq Party::DEFAULT_LOCATION
      end

      it "receives an impassable location" do
        party = Party.new(map: Map.new(tiles: [ [ Tile.new(passable: false) ] ]),
                            location: Couple.new(0,0))
        expect(party.map).to eq Party::DEFAULT_MAP
        expect(party.location).to eq Party::DEFAULT_LOCATION
      end
    end

  end

  context "add gold" do
    it "properly adds the appropriate amount of gold" do
      party = Party.new
      party.add_gold(30)
      expect(party.gold).to eq 30
    end

    it "prevents gold < 0" do
      party = Party.new
      party.add_gold(-30)
      expect(party.gold).to be_zero
    end
  end

  context "add item" do
    it "properly adds an item in a trivial case" do
      party = Party.new
      party.add_item(Item.new)
      expect(party.inventory.length).to eq 1
      expect(party.inventory[0].first).to eq Item.new
      expect(party.inventory[0].second).to eq 1
    end

    it "properly adds the same item to the same slot" do
      party = Party.new
      party.add_item(Item.new, 2)
      expect(party.inventory[0].second).to eq 2

      party.add_item(Item.new, 4)
      expect(party.inventory[0].second).to eq 6
      expect(party.inventory.length).to eq 1
    end

    it "handles multiple items being added in succession" do
      party = Party.new
      party.add_item(Item.new, 3)
      party.add_item(Item.new(name: "Apple"), 2)
      party.add_item(Item.new(name: "Orange"), 4)
      party.add_item(Item.new(name: "Apple"), 3)

      expect(party.inventory.length).to eq 3

      expect(party.inventory[0].first).to eq Item.new
      expect(party.inventory[0].second).to eq 3

      expect(party.inventory[1].first).to eq Item.new(name: "Apple")
      expect(party.inventory[1].second).to eq 5

      expect(party.inventory[2].first).to eq Item.new(name: "Orange")
      expect(party.inventory[2].second).to eq 4
    end
  end

  context "add member" do
    it "should add a member who has a unique name" do
      @beatles.add_member(Entity.new(name: "Pete"))
      expect(@beatles.members.size).to eq 5
    end

    it "should throw an error for a member with a non-unique name" do
      expect {@beatles.add_member(Entity.new(name: "George"))}.to raise_error
      expect(@beatles.members.size).to eq 4
    end
  end

  context "add rewards" do
    it "should give the player the appropriate amount of gold" do
      @party.add_rewards(5, nil)
      expect(@party.gold).to eq 5
      expect(@party.inventory.size).to be_zero
    end

    it "should give the player the appropriate treasure item" do
      @party.add_rewards(0, Item.new)
      expect(@party.gold).to be_zero
      expect(@party.inventory).to eq [Couple.new(Item.new, 1)]
    end

    it "should give the player both the gold and the treasure item" do
      @party.add_rewards(5, Item.new)
      expect(@party.gold).to eq 5
      expect(@party.inventory).to eq [Couple.new(Item.new, 1)]
    end

    it "should not output anything for no rewards" do
      expect { @party.add_rewards(0, nil) }.not_to output.to_stdout
    end

    it "should output both of the rewards" do
      expect { @party.add_rewards(5, Item.new) }.to output(
        "Rewards:\n* 5 gold\n* Item\n\n"
      ).to_stdout
    end
  end

  # TODO: implement battle.
  context "battle" do
    it "should allow the player to win in this example" do
      __stdin("use\nattack\n") do
        # @dude.battle(@slime)
      end
      # expect(@dude.inventory.size).to eq 1
    end

    it "should allow the player to escape in this example" do
      # Could theoretically fail, but with very low probability.
      __stdin("escape\nescape\nescape\n") do
        # @dude.battle(@slime)
      end
    end

    it "should allow the monster to win in this example" do
      __stdin("attack\n") do
        # @newb.battle(@dragon)
      end
      # Newb should die and go to respawn location.
      # expect(@newb.gold).to eq 25
      # expect(@newb.location).to eq Couple.new(1,1)
    end
  end

  context "has item" do
    it "correctly indicates an absent item for an object argument" do
      party = Party.new
      party.add_item(Item.new(name: "Apple"))
      party.add_item(Item.new(name: "Orange"))
      index = party.has_item(Item.new(name: "Banana"))
      expect(index).to be_nil
    end

    it "correctly indicates a present item for an object argument" do
      party = Party.new
      party.add_item(Item.new(name: "Apple"))
      party.add_item(Item.new(name: "Orange"))
      index = party.has_item(Item.new(name: "Apple"))
      expect(index).to eq 0
    end

    it "correctly indicates an absent item for a string argument" do
      party = Party.new
      party.add_item(Item.new(name: "Apple"))
      party.add_item(Item.new(name: "Orange"))
      index = party.has_item("Banana")
      expect(index).to be_nil
    end

    it "correctly indicates a present item for a string argument" do
      party = Party.new
      party.add_item(Item.new(name: "Apple"))
      party.add_item(Item.new(name: "Orange"))
      index = party.has_item("Orange")
      expect(index).to eq 1
    end
  end

  context "has member" do
    it "should return the index of a present member" do
      expect(@beatles.has_member("George")).to eq 2
      expect(@beatles.has_member("Paul")).to eq 1
      expect(@beatles.has_member("Ringo")).to eq 3
      expect(@beatles.has_member(Entity.new(name: "John"))).to eq 0
    end

    it "should return nil for a non-present member" do
      expect(@beatles.has_member("Neil")).to be_nil
    end
  end

  context "move to" do
    it "correctly moves the party to a passable tile" do
      @beatles.move_to(Couple.new(2,1))
      expect(@beatles.map).to eq @liverpool
      expect(@beatles.location).to eq Couple.new(2,1)
    end

    it "prevents the party from moving on an impassable tile" do
      @beatles.move_to(Couple.new(2,2))
      expect(@beatles.map).to eq @liverpool
      expect(@beatles.location).to eq @center
    end

    it "prevents the party from moving on a nonexistent tile" do
      @beatles.move_to(Couple.new(3,3))
      expect(@beatles.map).to eq @liverpool
      expect(@beatles.location).to eq @center
    end

    # TODO: must rewrite #battle.
    it "should (eventually) encounter a monster and do battle" do
      # High probability for encountering a monster at least once.
      20.times do
        __stdin("attack\n") do
          # @beatles.move_to(Couple.new(0,0), @monster_map)
        end
      end
    end
  end

  context "print inventory" do
    it "should print the inventory is empty when it is" do
      party = Party.new
      expect { party.print_inventory }.to output(
        "Current gold in pouch: 0.\n\nParty's inventory is empty!\n\n"
      ).to_stdout
    end

    it "should print the complete inventory when not empty" do
      apple = Item.new(name: "Apple")
      banana = Item.new(name: "Banana")
      party = Party.new(gold: 33, inventory: [
        Couple.new(apple, 1), Couple.new(banana, 2)] )
      expect { party.print_inventory }.to output(
        "Current gold in pouch: 33.\n\nParty's inventory:\n"\
        "* Apple (1)\n* Banana (2)\n\n"
      ).to_stdout
    end
  end

  context "print map" do
    it "should display as appropriate" do
      edge_row = "#{@impassable} #{@passable} #{@impassable} \n"
      middle_row = "#{@passable} ¶ #{@passable} \n"

      expect { @beatles.print_map }.to output(
        "   Map\n\n"\
        "  #{edge_row}"\
        "  #{middle_row}"\
        "  #{edge_row}"\
        "\n"\
        "   ¶ - Party's\n"\
        "       location\n\n"
      ).to_stdout
    end
  end

  context "print minimap" do
    it "should display as appropriate" do
      edge_row = "#{@impassable} #{@passable} #{@impassable} \n"
      middle_row = "#{@passable} ¶ #{@passable} \n"

      expect { @beatles.print_minimap }.to output(
        "\n"\
        "          #{edge_row}"\
        "          #{middle_row}"\
        "          #{edge_row}"\
        "          \n"
      ).to_stdout
    end
  end

  context "print tile" do
    it "should display the marker on the player's location" do
      expect { @beatles.print_tile(@beatles.location) }.to output("¶ ").to_stdout
    end

    it "should display the graphic of the tile elsewhere" do
      expect { @beatles.print_tile(Couple.new(0,0)) }.to output("#{@impassable} ").to_stdout
      expect { @beatles.print_tile(Couple.new(0,1)) }.to output("#{@passable} ").to_stdout
    end
  end

  context "remove gold" do
    it "should remove the given amount of gold" do
      party = Party.new(gold: 50)
      party.remove_gold(20)
      expect(party.gold).to eq 30
    end

    it "should prevent gold < 0" do
      party = Party.new(gold: 5)
      party.remove_gold(10)
      expect(party.gold).to be_zero
    end
  end

  context "remove item" do
    it "has no effect when no such item is present" do
      party = Party.new
      party.add_item(Item.new(name: "Apple"))
      party.remove_item(Item.new(name: "Banana"))
      expect(party.inventory.length).to eq 1
    end

    it "correctly removes the item in the trivial case" do
      party = Party.new
      party.add_item(Item.new(name: "Apple"))
      party.remove_item(Item.new(name: "Apple"))
      expect(party.inventory.length).to eq 0
    end

    it "correctly removes multiple of the same item" do
      party = Party.new
      party.add_item(Item.new(name: "Apple"), 4)
      party.remove_item(Item.new(name: "Apple"), 3)
      expect(party.inventory.length).to eq 1
      expect(party.inventory[0].first.name).to eq "Apple"
    end

    it "removes all of an item and leaves no gaps" do
      party = Party.new
      party.add_item(Item.new(name: "Apple"), 4)
      party.add_item(Item.new(name: "Banana"), 3)
      party.add_item(Item.new(name: "Orange"), 7)
      party.remove_item(Item.new(name: "Banana"), 6)

      expect(party.inventory.length).to eq 2
      expect(party.inventory[0].first.name).to eq "Apple"
      expect(party.inventory[1].first.name).to eq "Orange"
    end
  end

  context "remove member" do
    it "should remove a present member" do
      @beatles.remove_member("George")
      expect(@beatles.members.size).to eq 3
    end

    it "should have no effect for a non-present member" do
      @beatles.remove_member("Pete")
      expect(@beatles.members.size).to eq 4
    end
  end

  context "set gold" do
    it "should set the gold to the given amount" do
      party = Party.new(gold: 10)
      party.set_gold(15)
      expect(party.gold).to eq 15
    end

    it "should prevent gold < 0" do
      party = Party.new(gold: 5)
      party.set_gold(-10)
      expect(party.gold).to be_zero
    end
  end

  context "update map" do
    before(:each) do
      @line_map = Map.new(tiles: [ [ Tile.new, Tile.new, Tile.new, Tile.new ] ])
      @party = Party.new(map: @line_map, location: Couple.new(0, 0))
    end

    it "uses default argument to update tiles" do
      @party.update_map
      expect(@line_map.tiles[0][3].seen).to eq false
    end

    it "uses given argument to update tiles" do
      @party.update_map(Couple.new(0, 2))
      expect(@line_map.tiles[0][3].seen).to eq true
    end
  end

  context "use item" do
    it "correctly uses a present item for an object argument" do
      entity = Entity.new(max_hp: 20, hp: 10)
      party = Party.new(inventory: [Couple.new(Food.new(recovers: 5), 3)])
      party.use_item(Food.new, entity)
      expect(entity.hp).to eq 15
      expect(party.inventory[0].first).to eq Food.new
      expect(party.inventory[0].second).to eq 2
    end

    it "correctly uses a present item for a string argument" do
      entity = Entity.new(max_hp: 20, hp: 10)
      party = Party.new(inventory: [Couple.new(Food.new(recovers: 5), 3)])
      party.use_item("Food", entity)
      expect(entity.hp).to eq 15
      expect(party.inventory[0].first).to eq Food.new
      expect(party.inventory[0].second).to eq 2
    end
  end

end