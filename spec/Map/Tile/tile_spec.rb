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
  context "object clone method" do
    it "makes a deep copy of the object" do
      tile = Tile.new(description: "This is a test tile", events: [Event.new], monsters: [Monster.new])
      new_tile = tile.clone
      
      new_tile.events.pop
      new_tile.monsters.pop
      new_tile.description = "This is the deep-copied clone tile"
      
      expect(tile.events.length).not_to eq(0)
      expect(tile.monsters.length).not_to eq(0)
      expect(tile.description).not_to eq(new_tile.description)
    end
  end
end
