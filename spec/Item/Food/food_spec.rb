require_relative '../../../lib/Item/Food/food.rb'
require_relative '../../../lib/Entity/entity.rb'

RSpec.describe Food do

  before (:all) do
    @food = Food.new
    @magic_banana = Food.new(name: "Magic Banana", price: 5,
                             consumable: false, disposable: false,
                             recovers: 10)
  end

  context "constructor" do
    it "has the correct default parameters" do
      expect(@food.name).to eq "Food"
      expect(@food.price).to eq 0
      expect(@food.consumable).to eq true
      expect(@food.disposable).to eq true
      expect(@food.recovers).to eq 0
    end

    it "correctly assigns custom parameters" do
      expect(@magic_banana.name).to eq "Magic Banana"
      expect(@magic_banana.price).to eq 5
      expect(@magic_banana.consumable).to eq false
      expect(@magic_banana.disposable).to eq false
      expect(@magic_banana.recovers).to eq 10
    end
  end

  context "use" do
    it "heals the entity's HP in a trivial case" do
      entity = Entity.new(hp: 5, max_hp: 20)
      @magic_banana.use(entity, entity)
      expect(entity.hp).to eq 15
    end

    it "does not heal over the entity's max HP" do
      entity = Entity.new(hp: 15, max_hp: 20)
      @magic_banana.use(entity, entity)
      expect(entity.hp).to eq 20
    end
  end

  it "heals another entity's HP as appropriate" do
    bob = Entity.new(name: "Bob")
    marge = Entity.new(name: "Marge", hp: 5, max_hp: 20)
    @magic_banana.use(bob, marge)
    expect(marge.hp).to eq 15
  end

end
