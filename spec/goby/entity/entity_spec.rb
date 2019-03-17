require 'goby'

RSpec.describe Entity do
  let(:entity) { Entity.new }

  context "constructor" do
    it "has the correct default parameters" do
      expect(entity.name).to eq "Entity"
      stats = entity.stats
      expect(stats[:max_hp]).to eq 1
      expect(stats[:hp]).to eq 1
      expect(stats[:attack]). to eq 1
      expect(stats[:defense]).to eq 1
      expect(stats[:agility]).to eq 1
      expect(entity.inventory).to eq Array.new
      expect(entity.gold).to eq 0
      expect(entity.outfit).to eq Hash.new
    end

    it "correctly assigns custom parameters" do
      hero = Entity.new(name: "Hero",
                        stats: { max_hp: 50,
                                hp: 35,
                                attack: 12,
                                defense: 4,
                                agility: 9 },
                        inventory: [C[Item.new, 1]],
                        gold: 10,
                        outfit: { shield: Shield.new(
                                    stat_change: {attack: 3, defense: 1, agility: 4}
                                  ),
                                  helmet: Helmet.new(
                                      stat_change: {attack: 1, defense: 5}
                                  ) })
      expect(hero.name).to eq "Hero"
      stats = hero.stats
      expect(stats[:max_hp]).to eq 50
      expect(stats[:hp]).to eq 35
      # Attack & defense increase due to the equipped items.
      expect(stats[:attack]).to eq 16
      expect(stats[:defense]).to eq 10
      expect(stats[:agility]).to eq 13
      expect(hero.inventory).to eq [C[Item.new, 1]]
      expect(hero.gold).to eq 10
      expect(hero.outfit[:shield]).to eq Shield.new
      expect(hero.outfit[:helmet]).to eq Helmet.new
    end

    it "assigns default keyword arguments as appropriate" do
      entity = Entity.new(stats: { max_hp: 7,
                        defense: 9 },
                        gold: 3)
      expect(entity.name).to eq "Entity"
      stats = entity.stats
      expect(stats[:max_hp]).to eq 7
      expect(stats[:hp]).to eq 7
      expect(stats[:attack]).to eq 1
      expect(stats[:defense]).to eq 9
      expect(stats[:agility]).to eq 1
      expect(entity.inventory).to eq []
      expect(entity.gold).to eq 3
    end
  end

  context "add gold" do
    it "properly adds the appropriate amount of gold" do
      entity.add_gold(30)
      expect(entity.gold).to eq 30
    end

    it "prevents gold < 0" do
      entity.add_gold(-30)
      expect(entity.gold).to be_zero
    end
  end

  context "add item" do
    it "properly adds an item in a trivial case" do
      entity.add_item(Item.new)
      expect(entity.inventory.length).to eq 1
      expect(entity.inventory[0].first).to eq Item.new
      expect(entity.inventory[0].second).to eq 1
    end

    it "properly adds the same item to the same slot" do
      entity.add_item(Item.new, 2)
      expect(entity.inventory[0].second).to eq 2

      entity.add_item(Item.new, 4)
      expect(entity.inventory[0].second).to eq 6
      expect(entity.inventory.length).to eq 1
    end

    it "handles multiple items being added in succession" do
      entity.add_item(Item.new, 3)
      entity.add_item(Item.new(name: "Apple"), 2)
      entity.add_item(Item.new(name: "Orange"), 4)
      entity.add_item(Item.new(name: "Apple"), 3)

      expect(entity.inventory.length).to eq 3

      expect(entity.inventory[0].first).to eq Item.new
      expect(entity.inventory[0].second).to eq 3

      expect(entity.inventory[1].first).to eq Item.new(name: "Apple")
      expect(entity.inventory[1].second).to eq 5

      expect(entity.inventory[2].first).to eq Item.new(name: "Orange")
      expect(entity.inventory[2].second).to eq 4
    end
  end

  context "add rewards" do
    it "should give the player the appropriate amount of gold" do
      entity.add_loot(5, nil)
      expect(entity.gold).to eq 5
      expect(entity.inventory.size).to be_zero
    end

    it "should give the player the appropriate treasure item" do
      entity.add_loot(0, [Item.new])
      expect(entity.gold).to be_zero
      expect(entity.inventory).to eq [C[Item.new, 1]]
    end

    it "should give the player both the gold and all the treasures" do
      entity.add_loot(5, [Item.new, Helmet.new, Food.new])
      expect(entity.gold).to eq 5
      expect(entity.inventory.size).to eq 3
      expect(entity.inventory[0].first).to eq Item.new
      expect(entity.inventory[1].first).to eq Helmet.new
      expect(entity.inventory[2].first).to eq Food.new
    end

    it "should not give the player the nil treasure" do
      entity.add_loot(0, [Food.new, nil])
      expect(entity.inventory.size).to eq 1
      expect(entity.inventory[0].first).to eq Food.new
    end

    it "should not output anything for no rewards" do
      expect { entity.add_loot(0, nil) }.to output(
        "Loot: nothing!\n\n"
      ).to_stdout
    end

    it "should not output anything for empty treasures" do
      expect { entity.add_loot(0, []) }.to output(
        "Loot: nothing!\n\n"
      ).to_stdout
    end

    it "should not output anything for only nil treasures" do
      expect { entity.add_loot(0, [nil, nil] )}.to output(
        "Loot: nothing!\n\n"
      ).to_stdout
    end

    it "should output only the gold" do
      expect { entity.add_loot(3, nil) }.to output(
        "Loot: \n* 3 gold\n\n"
      ).to_stdout
    end

    it "should output only the treasures" do
      expect { entity.add_loot(0, [Item.new, Food.new]) }.to output(
        "Loot: \n* Item\n* Food\n\n"
      ).to_stdout
    end

    it "should output both of the rewards" do
      expect { entity.add_loot(5, [Item.new]) }.to output(
        "Loot: \n* 5 gold\n* Item\n\n"
      ).to_stdout
    end

    it "should output all of the rewards" do
      expect { entity.add_loot(7, [Item.new, Helmet.new, Food.new]) }.to output(
        "Loot: \n* 7 gold\n* Item\n* Helmet\n* Food\n\n"
      ).to_stdout
    end

    it "should not output the nil treasure" do
      expect { entity.add_loot(0, [Item.new, nil, Food.new]) }.to output(
        "Loot: \n* Item\n* Food\n\n"
      ).to_stdout
    end
  end

  context "clear inventory" do
    it "has no effect on an empty inventory" do
      entity.clear_inventory
      expect(entity.inventory.size).to be_zero
    end

    it "removes all items from a non-empty inventory" do
      entity = Entity.new(inventory: [C[Item.new, 4],
                                      C[Item.new(name: "Apple"), 3],
                                      C[Item.new(name: "Orange"), 7]])
      entity.clear_inventory
      expect(entity.inventory.size).to be_zero
    end
  end

  context "equip item" do
    it "correctly equips the helmet and alters the stats" do
      entity = Entity.new(inventory: [C[
                                        Helmet.new(stat_change: { defense: 3 } ), 1]])
      entity.equip_item("Helmet")
      expect(entity.outfit[:helmet]).to eq Helmet.new
      expect(entity.stats[:defense]).to eq 4
    end

    it "correctly equips the shield and alters the stats" do
      entity = Entity.new(inventory: [C[
                                        Shield.new(stat_change: { defense: 3,
                                                                  agility: 2 } ), 1]])
      entity.equip_item("Shield")
      expect(entity.outfit[:shield]).to eq Shield.new
      expect(entity.stats[:defense]).to eq 4
      expect(entity.stats[:agility]).to eq 3
    end

    it "correctly equips the legs and alters the stats" do
      entity = Entity.new(inventory: [C[
                                        Legs.new(stat_change: { defense: 3 } ), 1]])
      entity.equip_item("Legs")
      expect(entity.outfit[:legs]).to eq Legs.new
      expect(entity.stats[:defense]).to eq 4
    end

    it "correctly equips the torso and alters the stats" do
      entity = Entity.new(inventory: [C[
                                        Torso.new(stat_change: { defense: 3 } ), 1]])
      entity.equip_item("Torso")
      expect(entity.outfit[:torso]).to eq Torso.new
      expect(entity.stats[:defense]).to eq 4
    end

    it "does not equip anything for an absent item" do
      entity.equip_item("Weapon")
      expect(entity.outfit).to be_empty
    end

    it "only removes one of the equipped item from the inventory" do
      entity = Entity.new(inventory: [C[
                                        Helmet.new(stat_change: { defense: 3 } ), 2]])
      entity.equip_item("Helmet")
      expect(entity.inventory.length).to eq 1
      expect(entity.inventory[0].first).to eq Helmet.new
      expect(entity.inventory[0].second).to eq 1
    end

    it "correctly switches the equipped items and alters status as appropriate" do
      entity = Entity.new(inventory: [C[
                                        Helmet.new(name: "Builder",
                                                   stat_change: { attack: 3,
                                                                  defense: 2,
                                                                  agility: 4 }), 1],
                                      C[
                                        Helmet.new(name: "Viking",
                                                   stat_change: { attack: 5,
                                                                  defense: 3,
                                                                  agility: 7 }), 1]])
      entity.equip_item("Builder")
      stats = entity.stats
      expect(stats[:attack]).to eq 4
      expect(stats[:defense]).to eq 3
      expect(stats[:agility]).to eq 5
      expect(entity.outfit[:helmet].name).to eq "Builder"
      expect(entity.inventory.length).to eq 1
      expect(entity.inventory[0].first.name).to eq "Viking"

      entity.equip_item("Viking")
      stats = entity.stats
      expect(stats[:attack]).to eq 6
      expect(stats[:defense]).to eq 4
      expect(stats[:agility]).to eq 8
      expect(entity.outfit[:helmet].name).to eq "Viking"
      expect(entity.inventory.length).to eq 1
      expect(entity.inventory[0].first.name).to eq "Builder"
    end

    it "prints an error message for an unequippable item" do
      entity = Entity.new(inventory: [C[Item.new, 1]])
      expect { entity.equip_item("Item") }.to output(
        "Item cannot be equipped!\n\n"
      ).to_stdout
    end
  end

  context "entry from inventory" do
    it "correctly indicates an absent item for an object argument" do
      entity.add_item(Item.new(name: "Apple"))
      entity.add_item(Item.new(name: "Orange"))
      index = entity.inventory_entry(Item.new(name: "Banana"))
      expect(index).to be_nil
    end

    it "correctly indicates a present item for an object argument" do
      entity.add_item(Item.new(name: "Apple"))
      entity.add_item(Item.new(name: "Orange"))
      index = entity.inventory_entry(Item.new(name: "Apple"))
      expect(index).to eq C[Item.new(name: "Apple"), 1]
    end

    it "correctly indicates an absent item for a string argument" do
      entity.add_item(Item.new(name: "Apple"))
      entity.add_item(Item.new(name: "Orange"))
      index = entity.inventory_entry("Banana")
      expect(index).to be_nil
    end

    it "correctly indicates a present item for a string argument" do
      entity.add_item(Item.new(name: "Apple"))
      entity.add_item(Item.new(name: "Orange"))
      index = entity.inventory_entry("Orange")
      expect(index).to eq C[Item.new(name: "Orange"), 1]
    end
  end

  context "print inventory" do
    it "should print the inventory is empty when it is" do
      expect { entity.print_inventory }.to output(
        "Current gold in pouch: 0.\n\nEntity's inventory is empty!\n\n"
      ).to_stdout
    end

    it "should print the complete inventory when not empty" do
      apple = Item.new(name: "Apple")
      banana = Item.new(name: "Banana")
      entity = Entity.new(gold: 33, inventory: [
        C[apple, 1], C[banana, 2]] )
      expect { entity.print_inventory }.to output(
        "Current gold in pouch: 33.\n\nEntity's inventory:\n"\
        "* Apple (1)\n* Banana (2)\n\n"
      ).to_stdout
    end
  end

  context "print status" do
    it "prints all of the entity's information" do
      entity = Entity.new(stats: { max_hp: 50,
                                   hp: 30,
                                   attack: 5,
                                   defense: 3,
                                   agility: 4 },
                          outfit: { helmet: Helmet.new,
                                    legs: Legs.new,
                                    shield: Shield.new,
                                    torso: Torso.new,
                                    weapon: Weapon.new })
      expect { entity.print_status }.to output(
        "Stats:\n* HP: 30/50\n* Attack: 5\n* Defense: 3\n* Agility: 4\n\n"\
        "Equipment:\n* Weapon: Weapon\n* Shield: Shield\n* Helmet: Helmet\n"\
        "* Torso: Torso\n* Legs: Legs\n\n"
      ).to_stdout
    end

    it "prints the appropriate info for the default Entity" do
      expect { entity.print_status }.to output(
      "Stats:\n* HP: 1/1\n* Attack: 1\n* Defense: 1\n* Agility: 1\n\n"\
      "Equipment:\n* Weapon: none\n* Shield: none\n* Helmet: none\n"\
      "* Torso: none\n* Legs: none\n\n"
      ).to_stdout
    end
  end

  context "remove gold" do
    it "should remove the given amount of gold" do
      entity = Entity.new(gold: 50)
      entity.remove_gold(20)
      expect(entity.gold).to eq 30
    end

    it "should prevent gold < 0" do
      entity = Entity.new(gold: 5)
      entity.remove_gold(10)
      expect(entity.gold).to be_zero
    end
  end

  context "remove item" do
    it "has no effect when no such item is present" do
      entity.add_item(Item.new(name: "Apple"))
      entity.remove_item(Item.new(name: "Banana"))
      expect(entity.inventory.length).to eq 1
    end

    it "correctly removes the item in the trivial case" do
      entity.add_item(Item.new(name: "Apple"))
      entity.remove_item(Item.new(name: "Apple"))
      expect(entity.inventory.length).to eq 0
    end

    it "correctly removes multiple of the same item" do
      entity.add_item(Item.new(name: "Apple"), 4)
      entity.remove_item(Item.new(name: "Apple"), 3)
      expect(entity.inventory.length).to eq 1
      expect(entity.inventory[0].first.name).to eq "Apple"
    end

    it "removes all of an item and leaves no gaps" do
      entity.add_item(Item.new(name: "Apple"), 4)
      entity.add_item(Item.new(name: "Banana"), 3)
      entity.add_item(Item.new(name: "Orange"), 7)
      entity.remove_item(Item.new(name: "Banana"), 6)

      expect(entity.inventory.length).to eq 2
      expect(entity.inventory[0].first.name).to eq "Apple"
      expect(entity.inventory[1].first.name).to eq "Orange"
    end
  end

  context "set gold" do
    it "should set the gold to the given amount" do
      entity = Entity.new(gold: 10)
      entity.set_gold(15)
      expect(entity.gold).to eq 15
    end

    it "should prevent gold < 0" do
      entity = Entity.new(gold: 5)
      entity.set_gold(-10)
      expect(entity.gold).to be_zero
    end
  end

  context "unequip item" do
    it "correctly unequips an equipped item" do
      entity = Entity.new(outfit: { helmet: Helmet.new(stat_change: {agility: 4})})
      entity.unequip_item("Helmet")
      expect(entity.outfit).to be_empty
      expect(entity.inventory.length).to eq 1
      expect(entity.inventory[0].first).to eq Helmet.new
      expect(entity.inventory[0].second).to eq 1
      expect(entity.stats[:agility]).to eq 1
    end

    it "does not result in error when unequipping the same item twice" do
      entity = Entity.new(inventory: [C[
                                        Helmet.new(stat_change: { defense: 3 } ), 2]])
      entity.equip_item("Helmet")
      entity.unequip_item("Helmet")
      expect(entity.inventory.length).to eq 1
      expect(entity.inventory[0].first).to eq Helmet.new
      expect(entity.inventory[0].second).to eq 2

      entity.unequip_item("Helmet")
      expect(entity.inventory.length).to eq 1
      expect(entity.inventory[0].first).to eq Helmet.new
      expect(entity.inventory[0].second).to eq 2
    end
  end

  context "use item" do
    it "correctly uses a present item for an object argument" do
      entity = Entity.new(stats: { max_hp: 20, hp: 10 },
                          inventory: [C[Food.new(recovers: 5), 3]])
      entity.use_item(Food.new, entity)
      expect(entity.stats[:hp]).to eq 15
      expect(entity.inventory[0].first).to eq Food.new
      expect(entity.inventory[0].second).to eq 2
    end

    it "correctly uses a present item for a string argument" do
      entity = Entity.new(stats: { max_hp: 20, hp: 10 },
                          inventory: [C[Food.new(recovers: 5), 3]])
      entity.use_item("Food", entity)
      expect(entity.stats[:hp]).to eq 15
      expect(entity.inventory[0].first).to eq Food.new
      expect(entity.inventory[0].second).to eq 2
    end
  end

  context "equality operator" do
    it "returns true for the trivial case" do
      entity1 = Entity.new
      entity2 = Entity.new
      expect(entity1).to eq entity2
    end

    it "returns false for Entities with different names" do
      bob = Entity.new(name: "Bob")
      marge = Entity.new(name: "Marge")
      expect(bob).not_to eq marge
    end
  end

  context "set stats" do
    it "changes an entities stats" do
      entity = Entity.new(stats: { max_hp: 2, hp: 1, attack: 1, defense: 1, agility: 1 })

      entity.set_stats({ max_hp: 3, hp: 3, attack: 2, defense: 3, agility: 4 })

      stats = entity.stats
      expect(stats[:max_hp]).to eq 3
      expect(stats[:hp]).to eq 3
      expect(stats[:attack]).to eq 2
      expect(stats[:defense]).to eq 3
      expect(stats[:agility]).to eq 4
    end

    it "only changes specified stats" do
      entity = Entity.new(stats: { max_hp: 4, hp: 2, attack: 1, defense: 4, agility: 4 })

      entity.set_stats({ max_hp: 3, attack: 2 })

      stats = entity.stats
      expect(stats[:max_hp]).to eq 3
      expect(stats[:hp]).to eq 2
      expect(stats[:attack]).to eq 2
      expect(stats[:defense]).to eq 4
      expect(stats[:agility]).to eq 4
    end

    it "sets hp to max_hp if hp is passed in as nil" do
      entity.set_stats({ max_hp: 2, hp: nil })

      stats = entity.stats
      expect(stats[:max_hp]).to eq 2
      expect(stats[:hp]).to eq 2
    end

    it "hp cannot be more than max hp" do
      entity.set_stats({ max_hp: 2, hp: 3 })

      stats = entity.stats
      expect(stats[:max_hp]).to eq 2
      expect(stats[:hp]).to eq 2
    end

    it "non hp values cannot go below 1" do
      entity = Entity.new(stats: { max_hp: 2, attack: 3, defense: 2, agility: 3 })

      entity.set_stats({ max_hp: 0, attack: 0, defense: 0, agility: 0 })

      stats = entity.stats
      expect(stats[:max_hp]).to eq 1
      expect(stats[:attack]).to eq 1
      expect(stats[:defense]).to eq 1
      expect(stats[:agility]).to eq 1
    end

    it "hp cannot go below 0" do
      entity = Entity.new(stats: {hp: 3})

      entity.set_stats({hp: -1})

      stats = entity.stats
      expect(stats[:hp]).to eq 0
    end

    it "raises error if non-numeric passed in" do
      entity = Entity.new(stats: { attack: 11 })

      expect{ entity.set_stats({ attack: "foo" }) }.to raise_error

      expect(entity.stats[:attack]).to eq 11
    end

    it "only allows stats to be changed by calling set_stats" do
      entity = Entity.new(stats: { attack: 11 })

      expect do
        entity.stats = {attack: 9}
      end.to raise_exception

      expect do
        entity.stats[:attack] = 9
      end.to raise_exception

      expect(entity.stats[:attack]).to eq 11
    end
  end

end
