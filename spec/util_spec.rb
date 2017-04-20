RSpec.describe do

  context "add to history" do
    context "distinct commands" do
      it "should correctly add all commands to the history" do
        Readline::HISTORY.pop until Readline::HISTORY.size <= 0

        __stdin("kick\n") do
            player_input
        end

        __stdin("use\n") do
            player_input
        end

        __stdin("inv\n") do
            player_input
        end

        expect(Readline::HISTORY.size).to eq 3
        expect(Readline::HISTORY[-1]).to eq "inv"
      end
    end

    context "sequentially repeated commands" do
      it "should correctly add only the distinct commands to the history" do
        Readline::HISTORY.pop until Readline::HISTORY.size <= 0

        __stdin("kick\n") do
            player_input
        end

        __stdin("kick\n") do
            player_input
        end

        __stdin("inv\n") do
            player_input
        end

        __stdin("kick\n") do
            player_input
        end

        expect(Readline::HISTORY.size).to eq 3
        expect(Readline::HISTORY[0]).to eq "kick"
        expect(Readline::HISTORY[1]).to eq "inv"
      end
    end
  end

  context "do not add to history" do
    context "single character commands" do
      it "should correctly keep the history empty" do
        Readline::HISTORY.pop until Readline::HISTORY.size <= 0
        __stdin("w\n") do
          player_input
        end

        __stdin("a\n") do
          player_input
        end

        __stdin("s\n") do
          player_input
        end

        __stdin("d\n") do
          player_input
        end

        expect(Readline::HISTORY.size).to eq 0
      end
    end
  end

  context "increasing player_input versatility" do
    context "handling lowercase functionality" do
      it "should maintain case of input if no arguments are given" do
        inputs = ["KicK\n", "uSe\n", "INV\n"]
        Readline::HISTORY.pop until Readline::HISTORY.size <= 0

        inputs.each do |i|
          __stdin(i) { player_input }
        end

        expect(Readline::HISTORY.size).to eq 3
        i = 0
        expect(Readline::HISTORY.all? do |input|
          input == inputs[i]
          i += 1
        end).to eq true
      end

      it "returns lowercase input in lowercase is marked as true" do
        inputs = ["KicK\n", "uSe\n", "INV\n"]
        Readline::HISTORY.pop until Readline::HISTORY.size <= 0

        inputs.each do |i|
          __stdin(i) { player_input lowercase: true }
        end

        expect(Readline::HISTORY.size).to eq 3
        i = 0
        expect(Readline::HISTORY.all? do |input|
          input == inputs[i].downcase
          i += 1
        end).to eq true
      end
    end
  end
end
