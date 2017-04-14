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
  end
end