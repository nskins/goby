require_relative '../lib/world_command.rb'
require_relative '../lib/util.rb'
require_relative '../lib/Map/Map/map.rb'
require_relative '../lib/Entity/player.rb'


RSpec.describe do

  include WorldCommand

  before(:each) do
    @map = Map.new(tiles: [ [ Tile.new, 
                              Tile.new(events: [NPC.new]),
                              Tile.new(events: [Event.new(visible: false)]) ],
                            [ Tile.new(events: [Shop.new, NPC.new]), 
                              Tile.new(events: [Event.new(visible: false), Shop.new, NPC.new]) ] ],
                      regen_location: Couple.new(0,0))
    
    @player = Player.new(map: @map,
                         location: Couple.new(0, 0))
  end

  context "display default commands" do
    it "should print the default commands" do
      expect { display_default_commands }.to output(
        WorldCommand::DEFAULT_COMMANDS).to_stdout
    end
  end

  context "display special commands" do
    it "should print nothing when no special commands are available" do
      expect { display_special_commands(@player) }.to_not output.to_stdout
    end

    it "should print nothing when the only event is non-visible" do
      @player.move_right
      @player.move_right
      expect { display_special_commands(@player) }.to_not output.to_stdout
    end

    it "should print one commmand for one event" do
      @player.move_right
      expect { display_special_commands(@player) }.to output(
        WorldCommand::SPECIAL_COMMANDS_HEADER + "talk\n\n").to_stdout
    end

    it "should print two 'separated' commands for two events" do
      @player.move_down
      expect { display_special_commands(@player) }.to output(
        WorldCommand::SPECIAL_COMMANDS_HEADER + "shop, talk\n\n").to_stdout
    end

    it "should ignore the non-visible event" do
      @player.move_down
      @player.move_right
      expect { display_special_commands(@player) }.to output(
        WorldCommand::SPECIAL_COMMANDS_HEADER + "shop, talk\n\n").to_stdout
    end
  end

  context "help" do
    it "should print only the default commands when no special commands are available" do
      expect { help(@player) }.to output(WorldCommand::DEFAULT_COMMANDS).to_stdout
    end

    it "should print the default commands and the special commands" do
      @player.move_right
      expect { help(@player) }.to output(
        WorldCommand::DEFAULT_COMMANDS + WorldCommand::SPECIAL_COMMANDS_HEADER + 
        "talk\n\n").to_stdout
    end
  end

  # TODO: tests for describe_tile
  context "describe tile" do
    
  end

  # TODO: test the input of other commands.
  context "interpret command" do
    
    context "lowercase" do
      it "should correctly move the player around" do
        interpret_command("s", @player)
        expect(@player.location).to eq Couple.new(1, 0)
        interpret_command("d", @player)
        expect(@player.location).to eq Couple.new(1, 1)
        interpret_command("w", @player)
        expect(@player.location).to eq Couple.new(0, 1)
        interpret_command("a", @player)
        expect(@player.location).to eq Couple.new(0, 0)
      end

      it "should not drop a non-disposable item" do
        item = Item.new(name: "Onion", disposable: false)
        @player.add_item(item)
        interpret_command("drop onion", @player)
        expect(@player.has_item(item)).to eq 0
      end

      # TODO: Fix.
      it "should correctly create a save file" do
        interpret_command("save", @player)
        expect(File.file?("player.yaml")).to eq true
      end
    end
    
    context "case-insensitive" do
      it "should correctly move the player around" do
        interpret_command("S", @player)
        expect(@player.location).to eq Couple.new(1, 0)
        interpret_command("D", @player)
        expect(@player.location).to eq Couple.new(1, 1)
        interpret_command("W", @player)
        expect(@player.location).to eq Couple.new(0, 1)
        interpret_command("A", @player)
        expect(@player.location).to eq Couple.new(0, 0)
      end
    end
    
  end

end