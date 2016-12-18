require_relative 'shop.rb'
require_relative '../../Item/Equippable/Helmet/bucket.rb'
require_relative '../../Item/Equippable/Legs/ripped_pants.rb'
require_relative '../../Item/Equippable/Shield/riot_shield.rb'
require_relative '../../Item/Equippable/Torso/parka.rb'

class WackyClothesShop < Shop
  def initialize
    super(name: "the Wacky Clothes Shop", items: [Bucket.new, RippedPants.new, 
                                                  Parka.new, RiotShield.new])
  end
end
