require_relative '../../../lib/Event/Shop/shop.rb'
require_relative '../../Item/bait.rb'
require_relative '../../Item/fishing_pole.rb'
require_relative '../../Item/Food/egg.rb'
require_relative '../../Item/Food/fish.rb'
require_relative '../../Item/Food/fruits.rb'
require_relative '../../Item/Food/veggies.rb'

class FarmersMarket1 < Shop
  def initialize
    super(name: "the farmer's market",
          items: [Egg.new, Celery.new, Apple.new])
  end
end

class FarmersMarket2 < Shop
  def initialize
    super(name: "the farmer's market",
          items: [Grape.new, Onion.new, Potato.new])
  end
end

class FarmersMarket3 < Shop
  def initialize
    super(name: "the farmer's market",
          items: [Tomato.new, Strawberry.new, Pepper.new])
  end
end

class FishingShop < Shop
  def initialize
    super(name: "the fishing shop",
          items: [Snail.new, RawBluegill.new, FishingPole.new])
  end
end