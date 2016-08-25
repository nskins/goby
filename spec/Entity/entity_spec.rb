require_relative '../../src/Entity/entity.rb'
require_relative '../../src/Item/Equippable/Weapon/weapon.rb'
require_relative '../../src/Battle/BattleCommand/Attack/kick.rb'

RSpec.describe Entity do

  context "constructor" do
    it "has the correct default parameters" do
      entity = Entity.new
      expect(entity.name).to eq "Entity"
      expect(entity.max_hp).to eq 0
      expect(entity.hp).to eq 0
      expect(entity.attack). to eq 1
      expect(entity.defense).to eq 1
      expect(entity.inventory).to eq Array.new
      expect(entity.gold).to eq 0
      expect(entity.battle_commands).to eq Array.new
      expect(entity.outfit).to eq Hash.new
      expect(entity.escaped).to eq false
    end

    it "correctly assigns custom parameters" do
      hero = Entity.new(name: "Hero",
                        max_hp: 50,
                        hp: 35,
                        attack: 12,
                        defense: 4,
                        inventory: [Couple.new(Item.new, 1)],
                        gold: 10,
                        outfit: Hash[:weapon, Weapon.new(
                                    attack: Attack.new,
                                    stat_change: StatChange.new(
                                        attack: 3, defense: 1)),
                                  :helmet, Helmet.new(
                                      stat_change: StatChange.new(
                                              attack: 1, defense: 5)) ],
                        battle_commands: [Attack.new(name: "Kick")],
                        escaped: true)
      expect(hero.name).to eq "Hero"
      expect(hero.max_hp).to eq 50
      expect(hero.hp).to eq 35
      # Attack & defense increase due to the equipped items.
      expect(hero.attack).to eq 16
      expect(hero.defense).to eq 10
      expect(hero.inventory).to eq [Couple.new(Item.new, 1)]
      expect(hero.gold).to eq 10
      expect(hero.outfit[:weapon]).to eq Weapon.new
      expect(hero.outfit[:helmet]).to eq Helmet.new
      # Attack.new is present due to the equipped weapon.
      expect(hero.battle_commands).to eq [Attack.new, Attack.new(name: "Kick")]
      # cannot be overwritten.
      expect(hero.escaped).to eq false
    end
  end

  context "add battle command" do
    it "properly adds the command in a trivial case" do
      entity = Entity.new
      entity.add_battle_command(BattleCommand.new)
      expect(entity.battle_commands.length).to eq 1
      expect(entity.battle_commands).to eq [BattleCommand.new]
    end

    it "maintains the sorted invariant for a more complex case" do
      entity = Entity.new
      entity.add_battle_command(BattleCommand.new(name: "Kick"))
      entity.add_battle_command(BattleCommand.new(name: "Chop"))
      entity.add_battle_command(BattleCommand.new(name: "Grab"))
      expect(entity.battle_commands.length).to eq 3
      expect(entity.battle_commands).to eq [
        BattleCommand.new(name: "Chop"),
        BattleCommand.new(name: "Grab"),
        BattleCommand.new(name: "Kick")]
    end
  end

  context "add item" do
    it "properly adds an item in a trivial case" do
      entity = Entity.new
      entity.add_item(Item.new)
      expect(entity.inventory.length).to eq 1
      expect(entity.inventory[0].first).to eq Item.new
      expect(entity.inventory[0].second).to eq 1
    end

    it "properly adds the same item to the same slot" do
      entity = Entity.new
      entity.add_item(Item.new, 2)
      expect(entity.inventory[0].second).to eq 2

      entity.add_item(Item.new, 4)
      expect(entity.inventory[0].second).to eq 6
      expect(entity.inventory.length).to eq 1
    end

    it "handles multiple items being added in succession" do
      entity = Entity.new
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

  context "equip item by string" do
    it "correctly equips the weapon and alters the stats" do
      entity = Entity.new(inventory: [Couple.new(
                                        Weapon.new(stat_change: StatChange.new({ attack: 3 }) ), 1)])
      entity.equip_item_by_string("Weapon")
      expect(entity.outfit[:weapon]).to eq Weapon.new
      expect(entity.attack).to eq 4
    end

    it "correctly equips the helmet and alters the stats" do
      entity = Entity.new(inventory: [Couple.new(
                                        Helmet.new(stat_change: StatChange.new({ defense: 3 }) ), 1)])
      entity.equip_item_by_string("Helmet")
      expect(entity.outfit[:helmet]).to eq Helmet.new
      expect(entity.defense).to eq 4
    end
  end

  context "has battle command by object" do
    it "correctly indicates an absent command" do
      entity = Entity.new(battle_commands: [
        BattleCommand.new(name: "Kick"),
        BattleCommand.new(name: "Poke")])
      index = entity.has_battle_command_by_object(BattleCommand.new(name: "Chop"))
      expect(index).to eq -1
    end

    it "correctly indicates a present command" do
      entity = Entity.new(battle_commands: [
        BattleCommand.new(name: "Kick"),
        BattleCommand.new(name: "Poke")])
      index = entity.has_battle_command_by_object(BattleCommand.new(name: "Poke"))
      expect(index).to eq 1
    end
  end

  context "has battle command by string" do
    it "correctly indicates an absent command" do
      entity = Entity.new(battle_commands: [
        BattleCommand.new(name: "Kick"),
        BattleCommand.new(name: "Poke")])
      index = entity.has_battle_command_by_string("Chop")
      expect(index).to eq -1
    end

    it "correctly indicates a present command" do
      entity = Entity.new(battle_commands: [
        BattleCommand.new(name: "Kick"),
        BattleCommand.new(name: "Poke")])
      index = entity.has_battle_command_by_string("Poke")
      expect(index).to eq 1
    end
  end

  context "has item by object" do
    it "correctly indicates an absent item" do
      entity = Entity.new
      entity.add_item(Item.new(name: "Apple"))
      entity.add_item(Item.new(name: "Orange"))
      index = entity.has_item_by_object(Item.new(name: "Banana"))
      expect(index).to eq -1
    end

    it "correctly indicates a present item" do
      entity = Entity.new
      entity.add_item(Item.new(name: "Apple"))
      entity.add_item(Item.new(name: "Orange"))
      index = entity.has_item_by_object(Item.new(name: "Apple"))
      expect(index).to eq 0
    end
  end

  context "has item by string" do
    it "correctly indicates an absent item" do
      entity = Entity.new
      entity.add_item(Item.new(name: "Apple"))
      entity.add_item(Item.new(name: "Orange"))
      index = entity.has_item_by_string("Banana")
      expect(index).to eq -1
    end

    it "correctly indicates a present item" do
      entity = Entity.new
      entity.add_item(Item.new(name: "Apple"))
      entity.add_item(Item.new(name: "Orange"))
      index = entity.has_item_by_string("Orange")
      expect(index).to eq 1
    end
  end

  context "remove battle command" do
    it "has no effect when no such command is present" do
      entity = Entity.new
      entity.add_battle_command(Attack.new(name: "Kick"))
      entity.remove_battle_command(BattleCommand.new(name: "Poke"))
      expect(entity.battle_commands.length).to eq 1
    end

    it "correctly removes the command in the trivial case" do
      entity = Entity.new
      entity.add_battle_command(Attack.new(name: "Kick"))
      entity.remove_battle_command(Attack.new(name: "Kick"))
      expect(entity.battle_commands.length).to eq 0
    end
  end

  context "remove item" do
    it "has no effect when no such item is present" do
      entity = Entity.new
      entity.add_item(Item.new(name: "Apple"))
      entity.remove_item(Item.new(name: "Banana"))
      expect(entity.inventory.length).to eq 1
    end

    it "correctly removes the item in the trivial case" do
      entity = Entity.new
      entity.add_item(Item.new(name: "Apple"))
      entity.remove_item(Item.new(name: "Apple"))
      expect(entity.inventory.length).to eq 0
    end

    it "correctly removes multiple of the same item" do
      entity = Entity.new
      entity.add_item(Item.new(name: "Apple"), 4)
      entity.remove_item(Item.new(name: "Apple"), 3)
      expect(entity.inventory.length).to eq 1
      expect(entity.inventory[0].first.name).to eq "Apple"
    end

    it "removes all of an item and leaves no gaps" do
      entity = Entity.new
      entity.add_item(Item.new(name: "Apple"), 4)
      entity.add_item(Item.new(name: "Banana"), 3)
      entity.add_item(Item.new(name: "Orange"), 7)
      entity.remove_item(Item.new(name: "Banana"), 6)

      expect(entity.inventory.length).to eq 2
      expect(entity.inventory[0].first.name).to eq "Apple"
      expect(entity.inventory[1].first.name).to eq "Orange"
    end
  end

  context "use item by string" do
    it "correctly uses a present item" do
      entity = Entity.new(max_hp: 20, hp: 10,
                          inventory: [Couple.new(Food.new(recovers: 5), 3)])
      entity.use_item_by_string("Food", entity)
      expect(entity.hp).to eq 15
      expect(entity.inventory[0].first).to eq Food.new
      expect(entity.inventory[0].second).to eq 2
    end
  end

  context "use item by object" do
    it "correctly uses a present item" do
      entity = Entity.new(max_hp: 20, hp: 10,
                          inventory: [Couple.new(Food.new(recovers: 5), 3)])
      entity.use_item_by_object(Food.new, entity)
      expect(entity.hp).to eq 15
      expect(entity.inventory[0].first).to eq Food.new
      expect(entity.inventory[0].second).to eq 2
    end
  end

end
