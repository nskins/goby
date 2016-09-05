class Map

	# @param [Hash] params the parameters for creating a Map.
	# @option params [String] :name the name.
	# @option params [[Tile]] :tiles the content of the map.
	# @option params [Couple(Int,Int)] :regen_location the respawn-on-death coordinates.
	def initialize(params = {})
		@name = params[:name] || "Map"
		@tiles = params[:tiles] || [ [Tile.new ] ]
		@regen_location = params[:regen_location] || Couple.new(0,0)
	end

	# @param [Map] rhs the map on the right.
	def ==(rhs)
		return @name == rhs.name
	end

  # Prints the map in a nice format.
	def display
    #greeting
    puts "\nYou're in " + @name + "!\n\n";
    @tiles.each do |sub|
      #centers map under the greeting
      for i in 1..(name.length/2)
        print " "
      end
      sub.each do |tile|
        if tile.passable
          print "·"
        else
          print "■"
        end
      end
    puts ""
    end
		puts "\n· - passable space" +
         "\n■ - impassable space"
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

	attr_accessor :name, :tiles, :regen_location

end
