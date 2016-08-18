require_relative '../../../src/Event/Shop/shop.rb'

RSpec.describe Shop do
  
  context "constructor" do
    it "has the correct default parameters" do
      shop = Shop.new
      expect(shop.name).to eq "Shop"
      expect(shop.command).to eq "shop"
      expect(shop.mode).to eq 0
      expect(shop.visible).to eq true
    end

    it "correctly assigns custom parameters" do
      box = Shop.new(name: "Box",
                     command: "shop",
                     mode: 1,
                     visible: false)
      expect(box.command).to eq "shop"
      expect(box.mode).to eq 1
      expect(box.visible).to eq false
    end
  end

end
