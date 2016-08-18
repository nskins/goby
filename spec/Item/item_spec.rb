require_relative '../../src/Item/item.rb'

RSpec.describe Item do

  context "constructor" do
    it "has the correct default parameters" do
      item = Item.new
      expect(item.name).to eq "Item"
      expect(item.price).to eq 0
      expect(item.consumable).to eq true
    end

    it "correctly assigns custom parameters" do
      hammer = Item.new(name: "Hammer",
                        price: 40,
                        consumable: false)
      expect(hammer.name).to eq "Hammer"
      expect(hammer.price).to eq 40
      expect(hammer.consumable).to eq false
    end
  end

  context "equality operator" do
    it "returns true for the seemingly trivial case" do
      expect(Item.new).to eq Item.new
    end

    it "returns true when the names are the only same parameter" do
      item1 = Item.new(price: 30, consumable: true)
      item2 = Item.new(price: 40, consumable: false)
      expect(item1).to eq item2
    end

    it "returns false for items with different names" do
      hammer = Item.new(name: "Hammer")
      banana = Item.new(name: "Banana")
      expect(hammer).not_to eq banana
    end
  end
  
end
