class Tile
	
	# Default graphic for passable tiles.
	DEFAULT_PASSABLE = "·"
	# Default graphic for impassable tiles.
	DEFAULT_IMPASSABLE = "■"

	# @param [Hash] params the parameters for creating a Tile.
  # @option params [Boolean] :passable if true, the player can move here.
	# @option params [Boolean] :seen if true, it will be printed on the map.
	# @option params [String] :description a summary/message of the contents.
	# @option params [[Event]] :events the events found on this tile.
	# @option params [[Monster]] :monsters the monsters found on this tile.
	# @option params [String] :graphic the representation of the tile graphically.
	def initialize(params = {})
		if params[:passable].nil? then @passable = true
    else @passable = params[:passable] end

		if params[:seen].nil? then @seen = false
    else @seen = params[:seen] end

		@description = params[:description] || ""
		@events = params[:events] || Array.new
		@monsters = params[:monsters] || Array.new
		@graphic = params[:graphic] || default_graphic
	end

	# @param [Tile] rhs the tile on the right.
	def ==(rhs)
		return (@passable == rhs.passable &&
						@seen == rhs.seen &&
						@description == rhs.description)
	end

	attr_accessor :passable, :seen, :description, :events, :monsters, :graphic
	
	private 
	
		# Returns the default graphic by considering passable.
		def default_graphic
			return DEFAULT_PASSABLE if @passable
			return DEFAULT_IMPASSABLE
		end

end
