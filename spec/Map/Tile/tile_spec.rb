require_relative '../../../src/Map/Tile/tile.rb'
require_relative '../../../src/Event/event.rb'
require_relative '../../../src/Entity/Monster/monster.rb'

RSpec.describe Tile do

  context "constructor" do
    it "has the correct default parameters" do
      tile = Tile.new
      expect(tile.passable).to eq true
      expect(tile.seen).to eq false
      expect(tile.description).to eq ""
      expect(tile.events).to eq []
      expect(tile.monsters).to eq []
    end

    it "correctly assigns custom parameters" do
      pond = Tile.new(passable: false,
                      seen: true,
                      description: "Wet",
                      events: [Event.new],
                      monsters: [Monster.new])
      expect(pond.passable).to eq false
      expect(pond.seen).to eq true
      expect(pond.description).to eq "Wet"
      expect(pond.events).to eq [Event.new]
      expect(pond.monsters).to eq [Monster.new]
    end
  end

end
