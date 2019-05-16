# frozen_string_literal: true

require 'goby'

RSpec.describe Goby::Escape do

  let(:player) { Player.new }
  let(:monster) { Monster.new }
  let(:escape) { Escape.new }

  context "constructor" do
    it "has an appropriate default name" do
      expect(escape.name).to eq "Escape"
    end
  end

  context "run" do
    # The purpose of this test is to run the code without error.
    it "should return a usable result" do
      # Exercise both branches of this function w/ high probability.
      20.times do
        escape.run(player, monster)
        expect(player.escaped).to_not be nil
      end
    end
  end

end
