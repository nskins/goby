require_relative "../entity.rb"

class Monster < Entity

	# @param [Hash] params the parameters for creating a Monster.
  # @option params [String] :name the name.
  # @option params [Integer] :max_hp the greatest amount of health.
  # @option params [Integer] :hp the current amount of health.
  # @option params [Integer] :attack the strength in battle.
  # @option params [Integer] :defense the prevention of attack power on oneself.
  # @option params [[Couple(Item, Integer)]] :inventory a list of pairs of items and their respective amounts.
  # @option params [Integer] :gold the max amount of gold that can be rewarded to the opponent.
  # @option params [[BattleCommand]] :battle_commands the commands that can be used in battle.
  # @option params [Hash] :outfit the collection of equippable items currently worn.
	# @option params [String] :message the monster's battle cry.
	def initialize(params = {})
		super(params)
		@name = params[:name] || "Monster"
		@message = params[:message] || "!!!"
	end

	attr_accessor :message

end
