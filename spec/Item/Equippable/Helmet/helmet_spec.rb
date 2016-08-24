require_relative '../../../../src/Item/Equippable/Helmet/helmet.rb'

RSpec.describe Helmet do

  context "constructor" do
    it "has the correct default parameters" do
      helmet = Helmet.new
      expect(helmet.name).to eq "Helmet"
      expect(helmet.price).to eq 0
      expect(helmet.consumable).to eq false
      expect(helmet.stat_change).to eq StatChange.new({})
      expect(helmet.type).to eq :helmet
    end

    it "correctly assigns custom parameters" do
      big_hat = Helmet.new(name: "Big Hat",
                           price: 20,
                           consumable: true,
                           stat_change: StatChange.new(attack: 2,
                                                       defense: 2),
                           type: :weapon)
      expect(big_hat.name).to eq "Big Hat"
      expect(big_hat.price).to eq 20
      expect(big_hat.consumable).to eq true
      expect(big_hat.stat_change).to eq StatChange.new(attack: 2,
                                                       defense: 2)
      # Cannot be overwritten.
      expect(big_hat.type).to eq :helmet
    end
  end

end
