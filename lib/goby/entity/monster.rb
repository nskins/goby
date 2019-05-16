# frozen_string_literal: true

require 'goby'

module Goby

  # An Entity controlled by the CPU. Used for battle against Players.
  class Monster < Entity

    include Fighter

    # @param [String] name the name.
    # @param [Hash] stats hash of stats
    # @param [[C(Item, Integer)]] inventory an array of pairs of items and their respective amounts.
    # @param [Integer] gold the max amount of gold that can be rewarded to the opponent.
    # @param [[BattleCommand]] battle_commands the commands that can be used in battle.
    # @param [Hash] outfit the coolection of equippable items currently worn.
    # @param [[C(Item, Integer)]] treasures an array of treasures and the likelihood of receiving each.
    def initialize(name: "Monster", stats: {}, inventory: [], gold: 0, battle_commands: [], outfit: {},
                   treasures: [])
      super(name: name, stats: stats, inventory: inventory, gold: gold, outfit: outfit)
      @treasures = treasures

      # Find the total number of treasures in the distribution.
      @total_treasures = 0
      @treasures.each do |pair|
        @total_treasures += pair.second
      end

      add_battle_commands(battle_commands)
    end

    # Provides a deep copy of the monster. This is necessary since
    # the monster can use up its items in battle.
    #
    # @return [Monster] deep copy of the monster.
    def clone
      # Create a shallow copy for most of the variables.
      monster = super

      # Reset the copy's inventory.
      monster.inventory = []

      # Create a deep copy of the inventory.
      @inventory.each do |pair|
        monster.inventory << C[pair.first.clone, pair.second]
      end

      return monster
    end

    # What to do if the Monster dies in a Battle.
    def die
      # Do nothing special.
    end

    # What to do if a Monster wins a Battle.
    def handle_victory(fighter)
      # Take some of the Player's gold.
      fighter.sample_gold
    end

    # The amount gold given to a victorious Entity after losing a battle
    #
    # @return[Integer] the amount of gold to award the victorious Entity
    def sample_gold
      # Sample a random amount of gold.
      Random.rand(0..@gold)
    end

    # Chooses a treasure based on the sample distribution.
    #
    # @return [Item] the reward for the victor of the battle (or nil - no treasure).
    def sample_treasures
      # Return nil for no treasures.
      return if total_treasures.zero?

      # Choose uniformly from the total given above.
      index = Random.rand(total_treasures)

      # Choose the treasure based on the distribution.
      total = 0
      treasures.each do |pair|
        total += pair.second
        return pair.first if index < total
      end
    end

    attr_reader :treasures, :total_treasures
  end

end
