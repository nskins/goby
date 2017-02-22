require_relative '../../../lib/Item/Food/food.rb'
require_relative '../../../lib/Entity/entity.rb'

RSpec.describe Food do
  context "constructor" do
    it "has the correct default parameters" do
      food = Food.new
      expect(food.name).to eq "Food"
      expect(food.price).to eq 0
      expect(food.consumable).to eq true
      expect(food.disposable).to eq true
      expect(food.recovers).to eq 0
    end

    it "correctly assigns custom parameters" do
      magic_banana = Food.new(name: "Magic Banana",
                              price: 5,
                              consumable: false,
                              disposable: false,
                              recovers: 1000)
      expect(magic_banana.name).to eq "Magic Banana"
      expect(magic_banana.price).to eq 5
      expect(magic_banana.consumable).to eq false
      expect(magic_banana.disposable).to eq false
      expect(magic_banana.recovers).to eq 1000
    end
  end

  context "use" do
    it "heals the entity's HP in a trivial case" do
      entity = Entity.new(hp: 5, max_hp: 20)
      food = Food.new(recovers: 10)
      food.use(entity, entity)
      expect(entity.hp).to eq 15
    end

    it "does not heal over the entity's max HP" do
      entity = Entity.new(hp: 15, max_hp: 20)
      food = Food.new(recovers: 10)
      food.use(entity, entity)
      expect(entity.hp).to eq 20
    end
  end

end
