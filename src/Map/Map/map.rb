class Map

	def initialize(params = {})
		@name = params[:name] || "Map"
		@tiles = params[:tiles] || [ [Tile.new({})] ]
		@regen_location = params[:regen_location] || Couple.new(0,0)
	end

	def ==(rhs)
		return @name == rhs.name
	end

  # Prints the entire map.
	def print_map
    #greeting
    puts "\nYou're in " + @name + "!\n\n";
    @tiles.each do |sub|
      #centers map under the greeting
      for i in 1..(name.length/2)
        print " "
      end
      sub.each do |tile|
        if tile.passable
          print "•"
        else
          print "#"
        end
      end
    puts ""
    end
    puts "\n• - passable space" +
         "\n# - impassable space"
  end

	attr_accessor :name, :tiles, :regen_location

end
