require_relative '../../../src/Map/Map/map.rb'

RSpec.describe Map do

  context "constructor" do
    it "has the correct default parameters" do
      map = Map.new
      expect(map.name).to eq "Map"
      expect(map.tiles).to eq [ [ Tile.new ] ]
      expect(map.regen_location).to eq Couple.new(0,0)
    end

    it "correctly assigns custom parameters" do
      lake = Map.new(name: "Lake",
                     tiles: [ [ Tile.new, Tile.new ] ],
                     regen_location: Couple.new(0,1))
      expect(lake.name).to eq "Lake"
      expect(lake.tiles).to eq [ [ Tile.new, Tile.new ] ]
      expect(lake.regen_location).to eq Couple.new(0,1)
    end
  end

end
