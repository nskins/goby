require_relative "../entity.rb"

class Monster < Entity

  # @param [String] name the name.
  # @param [Integer] max_hp the greatest amount of health.
  # @param [Integer] hp the current amount of health.
  # @param [Integer] attack the strength in battle.
  # @param [Integer] defense the prevention of attack power on oneself.
	# @param [Integer] agility the speed in battle.
  # @param [[Couple(Item, Integer)]] inventory a list of pairs of items and their respective amounts.
  # @param [Integer] gold the max amount of gold that can be rewarded to the opponent.
  # @param [[BattleCommand]] battle_commands the commands that can be used in battle.
  # @param [Hash] outfit the collection of equippable items currently worn.
	# @param [String] message the monster's battle cry.
	def initialize(name: "Monster", max_hp: 1, hp: nil, attack: 1, defense: 1, agility: 1, 
								 inventory: [], gold: 0, battle_commands: [], outfit: {}, message: "!!!")
		super(name: name, max_hp: max_hp, hp: hp, attack: attack, defense: defense, agility: agility,
					inventory: inventory, gold: gold, battle_commands: battle_commands, outfit: outfit)
		@message = message
	end

	attr_accessor :message

end
