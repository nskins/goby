require 'goby'

RSpec.describe Goby::Battle do

  let(:dummy_fighter_class) {
    Class.new(Entity) do
      include Fighter

      def initialize(name: "Player", stats: {}, inventory: [], gold: 0, battle_commands: [], outfit: {})
        super(name: name, stats: stats, inventory: inventory, gold: gold, outfit: outfit)
        add_battle_commands(battle_commands)
      end
    end
  }

  context "constructor" do
    it "takes two arguments" do
      expect { Battle.new }.to raise_error(ArgumentError, "wrong number of arguments (given 0, expected 2)")

      entity_1 = entity_2 = double
      battle = Battle.new(entity_1, entity_2)
      expect(battle).to be_a Battle
    end
  end

  context "determine_winner" do
    it "prompts both entities to choose an attack" do
      entity_1 = spy('entity_1', stats: {agility: 1}, dead?: false)
      entity_2 = spy('entity_2', stats: {agility: 1}, dead?: false)
      Battle.new(entity_1, entity_2).determine_winner

      expect(entity_1).to have_received(:choose_attack)
      expect(entity_2).to have_received(:choose_attack)
    end

    it "returns the entity with positive hp" do
      entity_1 = dummy_fighter_class.new(name: "Player",
                                         stats: {max_hp: 20,
                                                 hp: 15,
                                                 attack: 2,
                                                 defense: 2,
                                                 agility: 4},
                                         outfit: {weapon: Weapon.new(
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

      entity_2 = dummy_fighter_class.new(name: "Clown",
                                         stats: {max_hp: 20,
                                                 hp: 15,
                                                 attack: 2,
                                                 defense: 2,
                                                 agility: 4},
                                         outfit: {weapon: Weapon.new(
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

      battle = Battle.new(entity_1, entity_2)
      winner = battle.determine_winner
      expect([entity_1, entity_2].include?(winner)).to be true

      loser = ([entity_1, entity_2] - [winner])[0]
      expect(winner.stats[:hp]).to be > 0
      expect(loser.stats[:hp]).to eql(0)
    end

  end
end