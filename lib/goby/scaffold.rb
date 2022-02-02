module Goby

  # Functions for scaffolding starter projects.
  module Scaffold

    # Simple starter project w/o testing.
    #
    # @param [String] project the project name.
    # @param [Boolean] boolean for deciding whether to init project on current or in a new directory
    def self.simple

      # TODO: detect existence of project folder.
      if File.exists? "src"
        puts "A src directory already exists, please create a new folder!"
        return
      end
      
      # Make the directory structure.
      dirs = [ '', 'battle', 'entity',
               'event', 'item', 'map' ]
      dirs.each do |dir|
        Dir.mkdir "src/#{dir}"
      end

      # Create the source files.
      gem_location = %x[gem which goby].chomp "/lib/goby.rb\n"
      files = { '.gitignore': '../gitignore',
                'src/main.rb': 'main.rb',
                'src/map/farm.rb': 'farm.rb' }
      files.each do |dest, source|
        File.open("#{dest.to_s}", 'w') do |w|
          w.write(File.read "#{gem_location}/res/scaffold/simple/#{source}")
        end
      end

    end

  end

end