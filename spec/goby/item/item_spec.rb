require 'goby'

RSpec.describe Item do
  let(:item) { Item.new }

  context "constructor" do
    it "has the correct default parameters" do
      expect(item.name).to eq "Item"
      expect(item.price).to eq 0
      expect(item.consumable).to eq true
      expect(item.disposable).to eq true
    end

    it "correctly assigns some custom parameters" do
      book = Item.new(name: "Book", disposable: false)
      expect(book.name).to eq "Book"
      expect(book.price).to eq 0
      expect(book.consumable).to eq true
      expect(book.disposable).to eq false
    end

    it "correctly assigns all custom parameters" do
      hammer = Item.new(name: "Hammer",
                        price: 40,
                        consumable: false,
                        disposable: false)
      expect(hammer.name).to eq "Hammer"
      expect(hammer.price).to eq 40
      expect(hammer.consumable).to eq false
      expect(hammer.disposable).to eq false
    end
  end

  context "use" do
    it "prints the default string for the base item" do
      user = Entity.new(name: "User") # who uses the item.
      whom = Entity.new(name: "Whom") # on whom the item is used.
      expect { item.use(user, whom) }.to output(Item::DEFAULT_USE_TEXT).to_stdout
    end
  end

  context "equality operator" do
    it "returns true for the seemingly trivial case" do
      expect(item).to eq Item.new
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

  context "to_s" do
    it "returns the name of the Item" do
      expect(item.to_s).to eq item.name
    end
  end

end
