require 'goby'

RSpec.describe Shop do

  before (:all) do
    @shop = Shop.new
    @tools = [Item.new(name: "Basket", price: 5),
              Item.new(name: "Knife", price: 10),
              Item.new(name: "Fork", price: 12),
              Item.new(name: "Screwdriver", price: 7)]
    @tool_shop = Shop.new(name: "Tool Shop",
                          mode: 1,
                          visible: false,
                          items: @tools)
    @apple = Item.new(name: "Apple", price: 2)
    @banana = Item.new(name: "Banana", disposable: false)
  end

  before (:each) do
    # party1 doesn't have any gold.
    @party1 = Party.new(inventory: [Couple.new(@apple, 3),
                                      Couple.new(@banana, 1)] )
    # party2 has nothing in the inventory.
    @party2 = Party.new(gold: 50)
  end

  context "constructor" do
    it "has the correct default parameters" do
      expect(@shop.name).to eq "Shop"
      expect(@shop.command).to eq "shop"
      expect(@shop.mode).to eq 0
      expect(@shop.visible).to eq true
      expect(@shop.items).to eq Array.new
    end

    it "correctly assigns custom parameters" do
      expect(@tool_shop.name).to eq "Tool Shop"
      expect(@tool_shop.command).to eq "shop"
      expect(@tool_shop.mode).to eq 1
      expect(@tool_shop.visible).to eq false
      expect(@tool_shop.items).to eq @tools
    end
  end

  context "buy" do
    it "should print an error message when the shop has nothing to sell" do
      expect { @shop.buy(@party2) }.to output(Shop::NO_ITEMS_MESSAGE).to_stdout
    end

    it "should return if the party doesn't want to buy anything" do
      __stdin("none\n") do
        @tool_shop.buy(@party2)
        expect(@party2.inventory.empty?).to be true
      end
    end

    it "should return if the party specifies a non-existent item" do
      __stdin("pencil\n") do
        @tool_shop.buy(@party2)
        expect(@party2.inventory.empty?).to be true
      end
    end

    it "should prevent the party from buying more than (s)he has in gold" do
      __stdin("fork\n5\n") do
        @tool_shop.buy(@party2)
        expect(@party2.inventory.empty?).to be true
      end
    end

    it "should prevent the party from buying a non-positive amount" do
      __stdin("fork\n0\n") do
        @tool_shop.buy(@party2)
        expect(@party2.inventory.empty?).to be true
      end
    end

    it "should sell the item to the party for a sensible purchase" do
      __stdin("fork\n2\n") do
        @tool_shop.buy(@party2)
        expect(@party2.inventory.empty?).to be false
        expect(@party2.gold).to be 26
        expect(@party2.has_item("Fork")).to eq 0
      end
    end
  end

  context "has item" do
    it "returns nil when no such item is available" do
      expect(@shop.has_item("Basket")).to be_nil
    end

    it "returns the index of the item when available" do
      expect(@tool_shop.has_item("Basket")).to be_zero
      expect(@tool_shop.has_item("Knife")).to eq 1
      expect(@tool_shop.has_item("Fork")).to eq 2
      expect(@tool_shop.has_item("Screwdriver")).to eq 3
    end
  end

  context "print gold and greeting" do
    it "prints the appropriate output" do
      __stdin("exit\n") do
        expect { @shop.print_gold_and_greeting(@party2) }.to output(
          "Current gold in your pouch: 50.\n"\
          "Would you like to buy, sell, or exit?: \n"\
        ).to_stdout
      end
    end

    it "returns the input (w/o newline)" do
      __stdin("buy\n") do
        expect(@shop.print_gold_and_greeting(@party2)).to eq "buy"
      end
    end
  end

  context "print items" do
    it "should print a helpful message when there's nothing to sell" do
      expect { @shop.print_items }.to output(Shop::NO_ITEMS_MESSAGE).to_stdout
    end

    it "should print the formatted list when there are items to sell" do
      expect { @tool_shop.print_items }.to output(
        "#{Shop::WARES_MESSAGE}"\
        "Basket (5 gold)\n"\
        "Knife (10 gold)\n"\
        "Fork (12 gold)\n"\
        "Screwdriver (7 gold)\n\n"
      ).to_stdout
    end
  end

  context "run" do
    it "should allow the party to buy an item" do
      __stdin("buy\nknife\n3\nexit\n") do
        @tool_shop.run(@party2)
        expect(@party2.gold).to eq 20
        expect(@party2.inventory.size).to eq 1
      end
    end

    it "should allow the party to sell an item" do
      __stdin("sell\napple\n3\nexit\n") do
        @tool_shop.run(@party1)
        expect(@party1.gold).to eq 3
        expect(@party1.inventory.size).to eq 1
      end
    end

    it "should allow the party to leave immediately" do
      __stdin("exit\n") do
        @tool_shop.run(@party1)
        expect(@party1.gold).to be_zero
        expect(@party1.inventory.size).to eq 2
      end
    end
  end

  context "sell" do
    it "should print an error message when the party has nothing to sell" do
      expect { @tool_shop.sell(@party2) }.to output(Shop::NOTHING_TO_SELL).to_stdout
    end

    it "should return if the party doesn't want to sell anything" do
      __stdin("none\n") do
        @tool_shop.sell(@party1)
        expect(@party1.gold).to be_zero
      end
    end

    it "should return if the party tries to sell a non-existent item" do
      __stdin("object\n") do
        @tool_shop.sell(@party1)
        expect(@party1.gold).to be_zero
      end
    end

    it "should return if the party tries to sell a non-disposable item" do
      __stdin("banana\n") do
        @tool_shop.sell(@party1)
        expect(@party1.gold).to be_zero
      end
    end

    it "should prevent the party from selling more than (s)he has" do
      __stdin("apple\n4\n") do
        @tool_shop.sell(@party1)
        expect(@party1.gold).to be_zero
      end
    end

    it "should prevent the party from selling a non-positive amount" do
      __stdin("apple\n0\n") do
        @tool_shop.sell(@party1)
        expect(@party1.gold).to be_zero
      end
    end

    it "should purchase the item for a sensible sale" do
      __stdin("apple\n3\n") do
        @tool_shop.sell(@party1)
        expect(@party1.gold).to be 3
        expect(@party1.inventory.size).to be 1
      end
    end
  end

end
