require 'goby'

RSpec.describe Map do

  let(:lake) { Map.new(name: "Lake",
                    tiles: [ [ Tile.new, Tile.new(passable: false) ] ] ) }

  context "constructor" do
    it "has the correct default parameters" do
      map = Map.new
      expect(map.name).to eq "Map"
      expect(map.tiles[0][0].passable).to be true
    end

    it "correctly assigns custom parameters" do
      expect(lake.name).to eq "Lake"
      expect(lake.tiles[0][0].passable).to be true
      expect(lake.tiles[0][1].passable).to be false
    end
  end

  context "to_s" do
    it "should display a simple map" do
      expect(lake.to_s).to eq("· ■ \n")
    end
  end

  context "in bounds" do
    it "returns true when the coordinates are within the map bounds" do
      expect(lake.in_bounds(0,0)).to eq true
      expect(lake.in_bounds(0,1)).to eq true
    end

    it "returns false when the coordinates are outside the map bounds" do
      expect(lake.in_bounds(-1,0)).to eq false
      expect(lake.in_bounds(0,-1)).to eq false
      expect(lake.in_bounds(-1,-1)).to eq false
      expect(lake.in_bounds(1,0)).to eq false
      expect(lake.in_bounds(0,2)).to eq false
      expect(lake.in_bounds(1,1)).to eq false
    end
  end

end
