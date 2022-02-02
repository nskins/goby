require 'goby'
require 'fileutils'

RSpec.describe Scaffold do

  context "simple" do
    it "should create the appropriate directories & files in the current directory" do

      Scaffold::simple

      # Ensure all of the directories exist.
      [ '', 'battle', 'entity',
      'event', 'item', 'map' ].each do |dir|
        expect(Dir.exist? "src/#{dir}").to be true
      end

      # Ensure all of the files exist.
      [ '.gitignore', 'src/main.rb', 'src/map/farm.rb' ].each do |file|
        expect(File.exist? "#{file}").to be true
      end

      # Clean up the scaffolding.
      FileUtils.remove_dir "src"
    end
  end

end