class Tile

	def initialize(params = {})
		# Passable tiles allow players to "be" there.
		if params[:passable].nil? then @passable = true
    else @passable = params[:passable] end

		# Seen tiles are visible on the printed map.
		if params[:seen].nil? then @seen = false
    else @seen = params[:seen] end

		# The description informs the player about the tile.
		@description = params[:description] || ""
		# The player interacts with events on the tile.
		@events = params[:events] || []
		# Monsters that appear randomly on this tile.
		@monsters = params[:monsters] || []
	end

	attr_accessor :passable, :seen, :description, :events, :monsters

end
