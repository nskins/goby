module Goby

  # Functions for scaffolding starter projects.
  module Scaffold

    # Simple starter project w/o testing.
    #
    # @param [String] project the project name.
    def self.simple(project)
      # Make the directory structure.
      Dir.mkdir project unless Dir.exist? project
      dirs = [ '', 'battle', 'entity',
               'event', 'item', 'map' ]
      dirs.each do |dir|
        Dir.mkdir "#{project}/src/#{dir}" unless Dir.exist? "#{project}/src/#{dir}"
      end

      # Create the source files.
      gem_location = %x[gem which goby].chomp "/lib/goby.rb\n"
      files = { '.gitignore': '../gitignore',
                'src/main.rb': 'main.rb',
                'src/map/farm.rb': 'farm.rb' }
      files.each do |dest, source|
        File.open("#{project}/#{dest.to_s}", 'w') do |w|
          w.write(File.read "#{gem_location}/res/scaffold/simple/#{source}")
        end
      end

    end

  end

end