require_relative "../entity.rb"

class Monster < Entity

	def initialize(params = {})
		super(params)
		@name = params[:name] || "Monster"

		if params[:visible].nil? then @visible = true
    else @visible = params[:visible] end

		if params[:regen].nil? then @regen = true
	  else @regen = params[:regen] end

		@message = params[:message] || "!!!"
	end

	# Override this method for control over the monster's battle commands.
	def choose_attack
	  return @battle_commands[Random.rand(@battle_commands.length)]
	end

	# TODO
	# function to assemble new inventory
	# from an array of preset items
	# each time a monster is regenerated

	# TODO: instead of using max_gold, perhaps 'gold' can serve the
	#       same purpose and we determine the reward at monster death.
	attr_accessor :visible, :regen, :message

end
