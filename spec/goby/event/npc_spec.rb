# frozen_string_literal: true

require 'goby'

RSpec.describe NPC do
  let(:npc) { NPC.new }
  let(:entity) { Entity.new }

  context "constructor" do
    it "has the correct default parameters" do
      expect(npc.name).to eq "NPC"
      expect(npc.command).to eq "talk"
      expect(npc.mode).to eq 0
      expect(npc.visible).to eq true
    end

    it "correctly assigns custom parameters" do
      john = NPC.new(name: "John",
                     mode: 1,
                     visible: false)
      expect(john.name).to eq "John"
      expect(john.command).to eq "talk" # Always talk command.
      expect(john.mode).to eq 1
      expect(john.visible).to eq false
    end
  end

  context "use" do
    it "prints the default text for the default NPC" do
      expect { npc.run(entity) }.to output("NPC: Hello!\n\n").to_stdout
    end
  end

  context "say" do
    subject(:npc) { NPC.new }

    it "outputs the NPC's name and words argument" do
      expect { npc.say("Welcome to Goby") }.to output("NPC: Welcome to Goby").to_stdout
    end
  end

end
