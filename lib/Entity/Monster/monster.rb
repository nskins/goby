require_relative "../entity.rb"

class Monster < Entity
  
  # @param [String] name the name.
  # @param [Integer] max_hp the greatest amount of health.
  # @param [Integer] hp the current amount of health.
  # @param [Integer] attack the strength in battle.
  # @param [Integer] defense the prevention of attack power on oneself.
  # @param [Integer] agility the speed in battle.
  # @param [[Couple(Item, Integer)]] inventory an array of pairs of items and their respective amounts.
  # @param [Integer] gold the max amount of gold that can be rewarded to the opponent.
  # @param [[BattleCommand]] battle_commands the commands that can be used in battle.
  # @param [Hash] outfit the coolection of equippable items currently worn.
  # @param [String] message the monster's battle cry.
  # @param [[Couple(Item, Integer)]] treasures an array of treasures and the likelihood of receiving each.
  def initialize(name: "Monster", max_hp: 1, hp: nil, attack: 1, defense: 1, agility: 1,
                 inventory: [], gold: 0, battle_commands: [], outfit: {}, message: "!!!",
                 treasures: [])
    super(name: name, max_hp: max_hp, hp: hp, attack: attack, defense: defense, agility: agility,
          inventory: inventory, gold: gold, battle_commands: battle_commands, outfit: outfit, message: message)
    @treasures = treasures
    
    # Find the total number of treasures in the distribution.
    @total_treasures = 0
    @treasures.each do |pair|
      @total_treasures += pair.second
    end
  end
  
  # Choose rewards based on the 'gold' and 'treasures' member variables.
  #
  # @return [Couple(Integer, Item)] the gold (first) and the treasure (second).
  def sample_rewards
    # Sample a random amount of gold.
    gold = Random.rand(0..@gold)
    
    # Determine which treasure to reward the victor.
    treasure = sample_treasures
    
    return Couple.new(gold, treasure)
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
      monster.inventory << Couple.new(pair.first.clone, pair.second)
    end
    
    return monster
  end
  
  attr_accessor :treasures, :total_treasures
  
  private
  
    # Chooses a treasure based on the sample distribution.
    #
    # @return [Item] the reward for the victor of the battle (or nil - no treasure).
    def sample_treasures
      # Choose uniformly from the total given above.
      index = Random.rand(@total_treasures)
      
      # Choose the treasure based on the distribution.
      total = 0
      @treasures.each do |pair|
        total += pair.second
        if index < total
          return pair.first
        end
      end
    end
    
end