require 'goby'

RSpec.describe Fighter do

  let!(:fighter) { Class.new { extend Fighter} }
  let(:entity) { Entity.new.extend(Fighter) }

  context "fighter" do
    it "is a fighter" do
      expect(fighter.fighter?).to be true
    end
  end

  context "placeholder methods" do
    it "forces :die to be implemented" do
      expect { fighter.die }.to raise_error(NotImplementedError, 'A Fighter Entity must know how to die')
    end

    it "forces :sample_treasures to be implemented" do
      expect { fighter.sample_treasures }.to raise_error(NotImplementedError, 'A Fighter Entity must know whether it returns treasure or not after losing a battle')
    end

    it "forces :sample_gold to be implemented" do
      expect { fighter.sample_gold }.to raise_error(NotImplementedError, 'A Fighter Entity must return some gold after losing a battle')
    end
  end

  context "add battle command" do
    it "properly adds the command in a trivial case" do
      entity.add_battle_command(BattleCommand.new)
      expect(entity.battle_commands.length).to eq 1
      expect(entity.battle_commands).to eq [BattleCommand.new]
    end

    it "maintains the sorted invariant for a more complex case" do
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

  context "choose attack" do
    it "randomly selects one of the available commands" do
      kick = BattleCommand.new(name: "Kick")
      zap = BattleCommand.new(name: "Zap")
      entity = Entity.new(battle_commands: [kick, zap]).extend(Fighter)
      attack = entity.choose_attack
      expect(attack.name).to eq("Kick").or(eq("Zap"))
    end
  end

  context "choose item and on whom" do
    it "randomly selects both item and on whom" do
      banana = Item.new(name: "Banana")
      axe = Item.new(name: "Axe")

      entity = Entity.new(inventory: [C[banana, 1],
                                      C[axe, 3]]).extend(Fighter)
      enemy = Entity.new(name: "Enemy").extend(Fighter)

      pair = entity.choose_item_and_on_whom(enemy)
      expect(pair.first.name).to eq("Banana").or(eq("Axe"))
      expect(pair.second.name).to eq("Entity").or(eq("Enemy"))
    end
  end

  context "eqip item" do
    it "correctly equips the weapon and alters the stats of a Fighter Entity" do
      entity = Entity.new(inventory: [C[
                                          Weapon.new(stat_change: { attack: 3 },
                                                     attack: Attack.new), 1]]).extend(Fighter)
      entity.equip_item("Weapon")
      expect(entity.outfit[:weapon]).to eq Weapon.new
      expect(entity.stats[:attack]).to eq 4
      expect(entity.battle_commands).to eq [Attack.new]
    end

    # it "correctly switches the equipped items and alters status as appropriate" do
    #   entity = Entity.new(inventory: [C[
    #                                       Weapon.new(name: "Hammer",
    #                                                  stat_change: { attack: 3,
    #                                                                 defense: 2,
    #                                                                 agility: 4 },
    #                                                  attack: Attack.new(name: "Bash")), 1],
    #                                   C[
    #                                       Weapon.new(name: "Knife",
    #                                                  stat_change: { attack: 5,
    #                                                                 defense: 3,
    #                                                                 agility: 7 },
    #                                                  attack: Attack.new(name: "Stab")), 1]])
    #   entity.equip_item("Hammer")
    #   stats = entity.stats
    #   expect(stats[:attack]).to eq 4
    #   expect(stats[:defense]).to eq 3
    #   expect(stats[:agility]).to eq 5
    #   expect(entity.outfit[:weapon].name).to eq "Hammer"
    #   expect(entity.battle_commands).to eq [Attack.new(name: "Bash")]
    #   expect(entity.inventory.length).to eq 1
    #   expect(entity.inventory[0].first.name).to eq "Knife"
    #
    #   entity.equip_item("Knife")
    #   stats = entity.stats
    #   expect(stats[:attack]).to eq 6
    #   expect(stats[:defense]).to eq 4
    #   expect(stats[:agility]).to eq 8
    #   expect(entity.outfit[:weapon].name).to eq "Knife"
    #   expect(entity.battle_commands).to eq [Attack.new(name: "Stab")]
    #   expect(entity.inventory.length).to eq 1
    #   expect(entity.inventory[0].first.name).to eq "Hammer"
    # end
  end

  context "has battle command" do
    it "correctly indicates an absent command for an object argument" do
      entity = Entity.new(battle_commands: [
                              BattleCommand.new(name: "Kick"),
                              BattleCommand.new(name: "Poke")]).extend(Fighter)
      index = entity.has_battle_command(BattleCommand.new(name: "Chop"))
      expect(index).to be_nil
    end

    it "correctly indicates a present command for an object argument" do
      entity = Entity.new(battle_commands: [
                              BattleCommand.new(name: "Kick"),
                              BattleCommand.new(name: "Poke")]).extend(Fighter)
      index = entity.has_battle_command(BattleCommand.new(name: "Poke"))
      expect(index).to eq 1
    end

    it "correctly indicates an absent command for a string argument" do
      entity = Entity.new(battle_commands: [
                              BattleCommand.new(name: "Kick"),
                              BattleCommand.new(name: "Poke")]).extend(Fighter)
      index = entity.has_battle_command("Chop")
      expect(index).to be_nil
    end

    it "correctly indicates a present command for a string argument" do
      entity = Entity.new(battle_commands: [
                              BattleCommand.new(name: "Kick"),
                              BattleCommand.new(name: "Poke")]).extend(Fighter)
      index = entity.has_battle_command("Poke")
      expect(index).to eq 1
    end
  end

  context "remove battle command" do
    it "has no effect when no such command is present" do
      entity.add_battle_command(Attack.new(name: "Kick"))
      entity.remove_battle_command(BattleCommand.new(name: "Poke"))
      expect(entity.battle_commands.length).to eq 1
    end

    it "correctly removes the command in the trivial case" do
      entity.add_battle_command(Attack.new(name: "Kick"))
      entity.remove_battle_command(Attack.new(name: "Kick"))
      expect(entity.battle_commands.length).to eq 0
    end
  end

end
