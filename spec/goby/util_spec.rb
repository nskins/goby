require 'goby'

RSpec.describe do
  context "Couple" do
    it "should correctly initialize the Couple" do
      couple = Couple.new("Apple", 1)
      expect(couple.first).to eq "Apple"
      expect(couple.second).to eq 1
    end

    it "should equate two objects based on both 'first' and 'second'" do
      couple1 = Couple.new("Apple", 1)
      couple2 = Couple.new("Apple", 1)
      expect(couple1).to eq couple2
    end

    it "should not equate two objects with a different 'first'" do
      couple1 = Couple.new("Apple", 1)
      couple2 = Couple.new("Banana", 1)
      expect(couple1).to_not eq couple2
    end

    it "should not equate two objects with a different 'second'" do
      couple1 = Couple.new("Apple", 1)
      couple2 = Couple.new("Apple", 2)
      expect(couple1).to_not eq couple2
    end

    it "should not equate two objects with both different 'first' and 'second'" do
      couple1 = Couple.new("Apple", 1)
      couple2 = Couple.new("Banana", 2)
      expect(couple1).to_not eq couple2
    end
  end

  context "player input" do
    before (:each) { Readline::HISTORY.pop until Readline::HISTORY.size <= 0 }

    it "should return the same string as given (without newline)" do
      __stdin("kick\n") do
        input = player_input
        expect(input).to eq "kick"
      end
    end

    it "should correctly add distinct commands to the history" do
      __stdin("kick\n") { player_input }
      __stdin("use\n") { player_input }
      __stdin("inv\n") { player_input }

      expect(Readline::HISTORY.size).to eq 3
      expect(Readline::HISTORY[-1]).to eq "inv"
    end

    it "should not add repeated commands to the history" do
      __stdin("kick\n") { player_input }
      __stdin("kick\n") { player_input }
      __stdin("inv\n") { player_input }
      __stdin("kick\n") { player_input }

      expect(Readline::HISTORY.size).to eq 3
      expect(Readline::HISTORY[0]).to eq "kick"
      expect(Readline::HISTORY[1]).to eq "inv"
    end

    it "should not add single-character commands to the history" do
      __stdin("w\n") { player_input }
      __stdin("a\n") { player_input }
      __stdin("s\n") { player_input }
      __stdin("d\n") { player_input }

      expect(Readline::HISTORY.size).to eq 0
    end
  end

  context "type" do
    it "should print the given message" do
      expect { type("HELLO") }.to output("HELLO").to_stdout
    end
  end

  context "save game" do
    it "should create the appropriate file" do
      player = Player.new
      save_game(player, "test.yaml")
      expect(File.file?("test.yaml")).to eq true
      File.delete("test.yaml")
    end
  end

  context "load game" do
    it "should load the player's information" do
      player1 = Player.new(name: "Nicholas", max_hp: 5, hp: 3)
      save_game(player1, "test.yaml")
      player2 = load_game("test.yaml")
      expect(player2.name).to eq "Nicholas"
      expect(player2.max_hp).to eq 5
      expect(player2.hp).to eq 3
      File.delete("test.yaml")
    end

    it "should return nil if no such file exists" do
      player = load_game("test.yaml")
      expect(player).to be_nil
    end
  end

  context "increasing player_input versatility" do
    context "handling lowercase functionality" do
      it "should maintain case of input if lowercase is marked as false" do
        inputs = ["KicK\n", "uSe\n", "INV\n"]
        Readline::HISTORY.pop until Readline::HISTORY.size <= 0

        inputs.each do |i|
          __stdin(i) { player_input lowercase: false }
        end

        expect(Readline::HISTORY.size).to eq 3
        i = 0
        expect(Readline::HISTORY.all? do |input|
          input == inputs[i]
          i += 1
        end).to eq true
      end

      it "returns lowercase input as default" do
        inputs = ["KicK\n", "uSe\n", "INV\n"]
        Readline::HISTORY.pop until Readline::HISTORY.size <= 0

        inputs.each do |i|
          __stdin(i) { player_input }
        end

        expect(Readline::HISTORY.size).to eq 3
        i = 0
        expect(Readline::HISTORY.all? do |input|
          input == inputs[i].downcase
          i += 1
        end).to eq true
      end
    end

    context "output is determined by given params" do
      it "prints an empty string and extra space by default" do
        expect{ __stdin('test') {player_input} }.to output("\n").to_stdout
      end

      it "prints the correct prompt when given an argument" do
        expect{ __stdin('test') {player_input prompt: '> '} }.to output("> \n").to_stdout
      end

      it "does not print the newline if doublespace is marked as false" do
        expect{ __stdin('test') {player_input doublespace: false} }.to output('').to_stdout
      end

      it "prints custom prompt and doesn't print the newline if doublespace is marked as false" do
        expect{ __stdin('test') {player_input doublespace: false, prompt: 'testing: '} }.to output("testing: ").to_stdout
      end
    end
  end
end
