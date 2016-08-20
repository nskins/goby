require_relative "../entity.rb"

class Monster < Entity

	def initialize(params = {})
		super(params)
		@name = params[:name] || "Monster"

		if params[:visible].nil? then @visible = true
    else @visible = params[:visible] end

		@message = params[:message] || "!!!"
	end

	# Override this method for control over the monster's battle commands.
	def choose_attack
	  return @battle_commands[Random.rand(@battle_commands.length)]
	end

	attr_accessor :visible, :message

end
