require 'goby'

RSpec.describe do

  include WorldCommand

  before(:each) do
    @map = Map.new(tiles: [ [ Tile.new,
                              Tile.new(events: [NPC.new]),
                              Tile.new(events: [Event.new(visible: false)]) ],
                            [ Tile.new(events: [Shop.new, NPC.new]),
                              Tile.new(events: [Event.new(visible: false), Shop.new, NPC.new]) ] ],
                      regen_location: Couple.new(0,0))

    @bob = Player.new(name: "Bob")
    @sally = Player.new(name: "Sally", max_hp: 10, hp: 3)
    @party = Party.new(members: [@bob, @sally],
                       inventory: [ Couple.new(Food.new(name: "Banana", recovers: 5), 1),
                                    Couple.new(Food.new(name: "Onion", disposable: false), 1),
                                    Couple.new(Item.new(name: "Big Book of Stuff"), 1),
                                    Couple.new(Helmet.new, 1) ],
                       map: @map,
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
      expect { display_special_commands(@party) }.to_not output.to_stdout
    end

    it "should print nothing when the only event is non-visible" do
      @party.move_right
      @party.move_right
      expect { display_special_commands(@party) }.to_not output.to_stdout
    end

    it "should print one commmand for one event" do
      @party.move_right
      expect { display_special_commands(@party) }.to output(
        WorldCommand::SPECIAL_COMMANDS_HEADER + "talk\n\n").to_stdout
    end

    it "should print two 'separated' commands for two events" do
      @party.move_down
      expect { display_special_commands(@party) }.to output(
        WorldCommand::SPECIAL_COMMANDS_HEADER + "shop, talk\n\n").to_stdout
    end

    it "should ignore the non-visible event" do
      @party.move_down
      @party.move_right
      expect { display_special_commands(@party) }.to output(
        WorldCommand::SPECIAL_COMMANDS_HEADER + "shop, talk\n\n").to_stdout
    end
  end

  context "help" do
    it "should print only the default commands when no special commands are available" do
      expect { help(@party) }.to output(WorldCommand::DEFAULT_COMMANDS).to_stdout
    end

    it "should print the default commands and the special commands" do
      @party.move_right
      expect { help(@party) }.to output(
        WorldCommand::DEFAULT_COMMANDS + WorldCommand::SPECIAL_COMMANDS_HEADER +
        "talk\n\n").to_stdout
    end
  end

  # TODO: tests for describe_tile
  context "describe tile" do
    it "should output the information about this tile" do
      describe_tile(@party)
    end
  end

  # TODO: test the input of all possible commands.
  # TODO: test use/drop/equip/unequip multi-word items.
  context "interpret command" do

    context "lowercase" do
      it "should print an error message for empty text" do
        expect { interpret_command("", @party) }.to output(
          WorldCommand::NO_COMMAND_ERROR
        ).to_stdout
        expect { interpret_command("      ", @party) }.to output(
          WorldCommand::NO_COMMAND_ERROR
        ).to_stdout
      end

      it "should print an error message for only a party member's name" do
        expect { interpret_command("bob", @party) }.to output(
          WorldCommand::NO_COMMAND_ERROR
        ).to_stdout
        expect { interpret_command("sally", @party) }.to output(
          WorldCommand::NO_COMMAND_ERROR
        ).to_stdout
      end

      it "should correctly move the party around" do
        interpret_command("s", @party)
        expect(@party.location).to eq Couple.new(1, 0)
        interpret_command("d", @party)
        expect(@party.location).to eq Couple.new(1, 1)
        interpret_command("w", @party)
        expect(@party.location).to eq Couple.new(0, 1)
        interpret_command("a", @party)
        expect(@party.location).to eq Couple.new(0, 0)
      end

      it "should display the help text" do
        expect { interpret_command("help", @party) }.to output(
          WorldCommand::DEFAULT_COMMANDS).to_stdout
      end

      it "should print the map" do
        expect { interpret_command("map", @party) }.to_not output(
          WorldCommand::NO_COMMAND_ERROR
        ).to_stdout
        # TODO: expect the map output.
      end

      it "should print the inventory" do
        expect { interpret_command("inv", @party) }.to_not output(
          WorldCommand::NO_COMMAND_ERROR
        ).to_stdout
        # TODO: expect the inventory output.
      end

      it "should print the entire party's status" do
        expect { interpret_command("status", @party) }.to output(
          "Bob:\n* HP: 1/1\n* Attack: 1\n* Defense: 1\n* Agility: 1\n\n"\
          "Sally:\n* HP: 3/10\n* Attack: 1\n* Defense: 1\n* Agility: 1\n\n"
        ).to_stdout
      end

      it "should print the specific party member's status" do
        interpret_command("sally status", @party)
        # TODO: expect the status output.
      end

      it "should print an error for an invalid party member's status" do
        expect { interpret_command("janet status", @party) }.to output(
          WorldCommand::NO_COMMAND_ERROR
        ).to_stdout
      end

      it "should save the game" do
        # Rename the original file.
        random_string = "n483oR38Avdis3"
        File.rename("party.yaml", random_string) if File.exists?("party.yaml")

        interpret_command("save", @party)
        expect(File.exists?("party.yaml")).to be true
        File.delete("party.yaml")

        # Return the original data to the file.
        File.rename(random_string, "party.yaml") if File.exists?(random_string)
      end

      it "should drop a disposable item" do
        interpret_command("drop banana", @party)
        expect(@party.has_item("Banana")).to be_nil
      end

      it "should drop the item composed of multiple words" do
        interpret_command("drop big book of stuff", @party)
        expect(@party.has_item("Big Book of Stuff")).to be_nil
      end

      it "should not drop a non-disposable item" do
        interpret_command("drop onion", @party)
        expect(@party.has_item("Onion")).to eq 1
      end

      it "should print error text for dropping nonexistent item" do
        expect { interpret_command("drop orange", @party) }.to output(
          WorldCommand::NO_ITEM_DROP_ERROR).to_stdout
      end

      it "should equip and unequip the specified item" do
        interpret_command("bob equip helmet", @party)
        expect(@party.has_item("Helmet")).to be_nil
        expect(@bob.outfit[:helmet]).to eq Helmet.new
        interpret_command("bob unequip helmet", @party)
        expect(@party.has_item("Helmet")).not_to be_nil
        expect(@bob.outfit[:helmet]).to be_nil
      end

      it "should print error text for not specifying item to equip" do
        expect { interpret_command("sally equip", @party) }.to output(
          WorldCommand::NO_COMMAND_ERROR).to_stdout
      end

      it "should print error text for not specifying item to unequip" do
        expect { interpret_command("sally unequip", @party) }.to output(
          WorldCommand::NO_COMMAND_ERROR).to_stdout
      end

      it "should print error text for equipping nonexistent item" do
        expect { interpret_command("sally equip trident", @party) }.to output(
          Party::NO_SUCH_ITEM_ERROR).to_stdout
      end

      it "should print error text when trying to unequip an item that's not equipped" do
        expect { interpret_command("sally unequip trident", @party) }.to output(
          Party::NOT_EQUIPPED_ERROR).to_stdout
      end

      it "should use the specified item" do
        interpret_command("sally use banana", @party)
        expect(@party.has_item("Banana")).to be_nil
        expect(@sally.hp).to eq 8
      end

      it "should print error text for not specifying item to use" do
        expect { interpret_command("sally use", @party) }.to output(
          WorldCommand::NO_COMMAND_ERROR).to_stdout
      end

      it "should print error text for using nonexistent item" do
        expect { interpret_command("sally use apple", @party) }.to output(
          Entity::NO_SUCH_ITEM_ERROR).to_stdout
      end

      it "should run the event on the tile" do
        @party.move_right
        expect { interpret_command("talk\n", @party) }.to output(
          "NPC: Hello!\n\n").to_stdout
      end

    end

    context "case-insensitive" do
      it "should correctly move the party around" do
        interpret_command("S", @party)
        expect(@party.location).to eq Couple.new(1, 0)
        interpret_command("D", @party)
        expect(@party.location).to eq Couple.new(1, 1)
        interpret_command("W", @party)
        expect(@party.location).to eq Couple.new(0, 1)
        interpret_command("A", @party)
        expect(@party.location).to eq Couple.new(0, 0)
      end
    end

  end

end