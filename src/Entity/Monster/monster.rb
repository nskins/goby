require_relative "../entity.rb"

class Monster < Entity

	def initialize(params = {})
		super(params)
		@name = params[:name] || "Monster"

		if params[:visible].nil? then @visible = true
    else @visible = params[:visible] end

		@message = params[:message] || "!!!"
	end

	attr_accessor :visible, :message

end
