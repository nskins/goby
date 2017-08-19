require 'goby'
require 'fileutils'

RSpec.describe Scaffold do

  context "simple" do
    it "should create the appropriate directories & files" do

      project = "goby-project"
      Scaffold::simple project

      # Ensure all of the directories exist.
      expect(Dir.exists? "#{project}").to be true
      [ '', 'battle', 'entity',
      'event', 'item', 'map' ].each do |dir|
        expect(Dir.exist? "#{project}/src/#{dir}").to be true
      end

      # Ensure all of the files exist.
      [ '.gitignore', 'src/main.rb', 'src/map/farm.rb' ].each do |file|
        expect(File.exist? "#{project}/#{file}").to be true
      end

      # Clean up the scaffolding.
      FileUtils.remove_dir project

    end
  end

end