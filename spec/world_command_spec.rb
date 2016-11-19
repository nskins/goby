require_relative '../lib/world_command.rb'
require_relative '../lib/util.rb'
require_relative '../lib/Map/Map/map.rb'
require_relative '../lib/Entity/player.rb'


RSpec.describe do
  
  before(:all) do
    @square = Map.new(name: "Square",
                      tiles: [ [ Tile.new, Tile.new ],
                               [ Tile.new, Tile.new ] ],
                      regen_location: Couple.new(0,0))
    
    @player = Player.new(map: @square,
                         location: Couple.new(0, 0))
  end
  
  context "interpret command" do
    
    context "lowercase" do
      it "should correctly move the player down" do
        interpret_command("s", @player)
        expect(@player.location).to eq Couple.new(1, 0)
      end
    
      it "should correctly move the player right" do
        interpret_command("e", @player)
        expect(@player.location).to eq Couple.new(1, 1)
      end
    
      it "should correctly move the player up" do
        interpret_command("n", @player)
        expect(@player.location).to eq Couple.new(0, 1)
      end
    
      it "should correctly move the player left" do
        interpret_command("w", @player)
        expect(@player.location).to eq Couple.new(0, 0)
      end
    end
    
    context "case-insensitive" do
      it "should correctly move the player down" do
        interpret_command("S", @player)
        expect(@player.location).to eq Couple.new(1, 0)
      end
    
      it "should correctly move the player right" do
        interpret_command("E", @player)
        expect(@player.location).to eq Couple.new(1, 1)
      end
    
      it "should correctly move the player up" do
        interpret_command("N", @player)
        expect(@player.location).to eq Couple.new(0, 1)
      end
    
      it "should correctly move the player left" do
        interpret_command("W", @player)
        expect(@player.location).to eq Couple.new(0, 0)
      end
    end
    
  end

end