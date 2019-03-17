require 'goby'

RSpec.describe do

  include WorldCommand

  let!(:map) { Map.new(tiles: [ [ Tile.new,
                              Tile.new(events: [NPC.new]),
                              Tile.new(events: [Event.new(visible: false)]) ],
                            [ Tile.new(events: [Shop.new, NPC.new]),
                              Tile.new(events: [Event.new(visible: false), Shop.new, NPC.new]) ] ] ) }

  let!(:player) { Player.new(stats: { max_hp: 10, hp: 3 },
                         inventory: [ C[Food.new(name: "Banana", recovers: 5), 1],
                                      C[Food.new(name: "Onion", disposable: false), 1],
                                      C[Item.new(name: "Big Book of Stuff"), 1],
                                      C[Helmet.new, 1] ],
                         location: Location.new(map, C[0, 0])) }

  context "display special commands" do
    it "should print nothing when no special commands are available" do
      expect { display_special_commands(player) }.to_not output.to_stdout
    end

    it "should print nothing when the only event is non-visible" do
      player.move_right
      player.move_right
      expect { display_special_commands(player) }.to_not output.to_stdout
    end

    it "should print one commmand for one event" do
      player.move_right
      expect { display_special_commands(player) }.to output(
        WorldCommand::SPECIAL_COMMANDS_HEADER + "talk\n\n").to_stdout
    end

    it "should print two 'separated' commands for two events" do
      player.move_down
      expect { display_special_commands(player) }.to output(
        WorldCommand::SPECIAL_COMMANDS_HEADER + "shop, talk\n\n").to_stdout
    end

    it "should ignore the non-visible event" do
      player.move_down
      player.move_right
      expect { display_special_commands(player) }.to output(
        WorldCommand::SPECIAL_COMMANDS_HEADER + "shop, talk\n\n").to_stdout
    end
  end

  context "help" do
    it "should print only the default commands when no special commands are available" do
      expect { help(player) }.to output(WorldCommand::DEFAULT_COMMANDS).to_stdout
    end

    it "should print the default commands and the special commands" do
      player.move_right
      expect { help(player) }.to output(
        WorldCommand::DEFAULT_COMMANDS + WorldCommand::SPECIAL_COMMANDS_HEADER +
        "talk\n\n").to_stdout
    end
  end

  # TODO: tests for describe_tile
  context "describe tile" do

  end

  # TODO: test the input of all possible commands.
  # TODO: test use/drop/equip/unequip multi-word items.
  context "interpret command" do

    context "lowercase" do
      it "should correctly move the player around" do
        interpret_command("s", player)
        expect(player.location.coords).to eq C[1, 0]
        interpret_command("d", player)
        expect(player.location.coords).to eq C[1, 1]
        interpret_command("w", player)
        expect(player.location.coords).to eq C[0, 1]
        interpret_command("a", player)
        expect(player.location.coords).to eq C[0, 0]
      end

      it "should display the help text" do
        expect { interpret_command("help", player) }.to output(
          WorldCommand::DEFAULT_COMMANDS).to_stdout
      end

      it "should print the map" do
        interpret_command("map", player)
        # TODO: expect the map output.
      end

      it "should print the inventory" do
        interpret_command("inv", player)
        # TODO: expect the inventory output.
      end

      it "should print the status" do
        interpret_command("status", player)
        # TODO: expect the status output.
      end

      it "should save the game" do
        # Rename the original file.
        random_string = "n483oR38Avdis3"
        File.rename("player.yaml", random_string) if File.exists?("player.yaml")

        interpret_command("save", player)
        expect(File.exists?("player.yaml")).to be true
        File.delete("player.yaml")

        # Return the original data to the file.
        File.rename(random_string, "player.yaml") if File.exists?(random_string)
      end

      it "should drop a disposable item" do
        interpret_command("drop banana", player)
        expect(player.entry_from_inventory("Banana")).to be_nil
      end

      it "should drop the item composed of multiple words" do
        interpret_command("drop big book of stuff", player)
        expect(player.entry_from_inventory("Big Book of Stuff")).to be_nil
      end

      it "should not drop a non-disposable item" do
        interpret_command("drop onion", player)
        expect(player.item_from_inventory("Onion")).not_to be_nil
      end

      it "should print error text for dropping nonexistent item" do
        expect { interpret_command("drop orange", player) }.to output(
          WorldCommand::NO_ITEM_DROP_ERROR).to_stdout
      end

      it "should not output anything on quit" do
        expect { interpret_command("quit", @player) }.to_not output.to_stdout
      end

      it "should equip and unequip the specified item" do
        interpret_command("equip helmet", player)
        expect(player.entry_from_inventory("Helmet")).to be_nil
        expect(player.outfit[:helmet]).to eq Helmet.new
        interpret_command("unequip helmet", player)
        expect(player.entry_from_inventory("Helmet")).not_to be_nil
        expect(player.outfit[:helmet]).to be_nil
      end

      it "should use the specified item" do
        interpret_command("use banana", player)
        expect(player.entry_from_inventory("Banana")).to be_nil
        expect(player.stats[:hp]).to eq 8
      end

      it "should print error text for using nonexistent item" do
        expect { interpret_command("use apple", player) }.to output(
          Entity::NO_SUCH_ITEM_ERROR).to_stdout
      end

      it "should run the event on the tile" do
        player.move_right
        expect { interpret_command("talk\n", player) }.to output(
          "NPC: Hello!\n\n").to_stdout
      end

    end

    context "case-insensitive" do
      it "should correctly move the player around" do
        interpret_command("S", player)
        expect(player.location.coords).to eq C[1, 0]
        interpret_command("D", player)
        expect(player.location.coords).to eq C[1, 1]
        interpret_command("W", player)
        expect(player.location.coords).to eq C[0, 1]
        interpret_command("A", player)
        expect(player.location.coords).to eq C[0, 0]
      end
    end

  end

end
