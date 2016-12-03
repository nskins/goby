require_relative '../../../lib/Map/Tile/tile.rb'
require_relative '../../../lib/Event/event.rb'
require_relative '../../../lib/Entity/Monster/monster.rb'

RSpec.describe Tile do

  context "constructor" do
    it "has the correct default parameters" do
      tile = Tile.new
      expect(tile.passable).to eq true
      expect(tile.seen).to eq false
      expect(tile.description).to eq ""
      expect(tile.events).to eq []
      expect(tile.monsters).to eq []
      expect(tile.graphic).to eq "·"
    end
    
    it "correctly assigns default graphic for non-passable tiles" do
      tile = Tile.new(passable:false)
      expect(tile.graphic).to eq "■"
    end

    it "correctly assigns custom parameters" do
      pond = Tile.new(passable: false,
                      seen: true,
                      description: "Wet",
                      events: [Event.new],
                      monsters: [Monster.new],
                      graphic: '#')
      expect(pond.passable).to eq false
      expect(pond.seen).to eq true
      expect(pond.description).to eq "Wet"
      expect(pond.events).to eq [Event.new]
      expect(pond.monsters).to eq [Monster.new]
      expect(pond.graphic).to eq '#'
    end
  end

  context "equality operator" do
    it "returns true for the seemingly trivial case" do
      expect(Tile.new).to eq Tile.new
    end

    it "returns true when only events and monsters are different" do
      tile1 = Tile.new(events: [Event.new(command: "open")],
                       monsters: [Monster.new(name: "Clown")])
      tile2 = Tile.new(events: [Event.new(command: "close")],
                       monsters: [Monster.new(name: "Alien")])
      expect(tile1).to eq tile2
    end

    it "returns false for tiles with different passable attributes" do
      dirt = Tile.new(passable: true)
      wall = Tile.new(passable: false)
      expect(dirt).not_to eq wall
    end

    it "returns false for tiles with different seen attributes" do
      tile1 = Tile.new(seen: true)
      tile2 = Tile.new(seen: false)
      expect(tile1).not_to eq tile2
    end

    it "returns false for tiles with different descriptions" do
      dirt = Tile.new(description: "Dirt surrounds you.")
      water = Tile.new(description: "Water surrounds you.")
      expect(dirt).not_to eq water
    end
  end

end
