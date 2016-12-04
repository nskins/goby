class Map

	# @param [Hash] params the parameters for creating a Map.
	# @option params [String] :name the name.
	# @option params [[Tile]] :tiles the content of the map.
	# @option params [Couple(Int,Int)] :regen_location the respawn-on-death coordinates.
	# @option params [String] :music the filename of the music file.
	def initialize(params = {})
		@name = params[:name] || "Map"
		@tiles = params[:tiles] || [ [Tile.new ] ]
		@regen_location = params[:regen_location] || Couple.new(0,0)
		
		_relativePATH = File.expand_path File.dirname(__FILE__)
		@music = _relativePATH + params[:music] if params[:music]
	end
	
	def play_music
		stop_music
		$pid = Process.spawn "while true; do aplay #{@music}; done"
	end
	
	def stop_music
		if $pid
			Process.kill(15, $pid)
			$pid = nil
		end
	end

	# @param [Map] rhs the map on the right.
	def ==(rhs)
		return @name == rhs.name
	end

  # Prints the map in a nice format.
	def to_s
		output = ""
    @tiles.each do |row|
      row.each do |tile|
        output += (tile.graphic + " ")
      end
			output += "\n"
    end
		return output
  end

	# Returns true when @tiles[y][x] is an existing index of @tiles.
	# Otherwise, returns false.
	#
	# @param [Integer] y the y-coordinate.
	# @param [Integer] x the x-coordinate.
	# @return [Boolean] the existence of the tile.
	def in_bounds(y, x)
		return (y >= 0 && y < @tiles.length && x >= 0 && x < @tiles[y].length)
	end

	attr_accessor :name, :tiles, :regen_location, :music

end

# For manually testing this individual file (will need to comment out @tiles &@regen_locations in initialize)
# @map = Map.new
# @map.play_music(true)
# @map.play_music(false)