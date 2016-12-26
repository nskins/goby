require_relative '../../../lib/Battle/BattleCommand/escape.rb'

RSpec.describe Escape do
  
  context "constructor" do
    it "has an appropriate default name" do
      escape = Escape.new
      expect(escape.name).to eq "Escape"
    end
  end
  
end