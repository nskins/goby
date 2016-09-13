require_relative 'shop.rb'
require_relative '../../Item/Equippable/Helmet/bucket.rb'
require_relative '../../Item/Equippable/Legs/ripped_pants.rb'
require_relative '../../Item/Equippable/Shield/riot_shield.rb'
require_relative '../../Item/Equippable/Torso/parka.rb'

class WackyClothesShop < Shop
  def initialize(params = { name: "the Wacky Clothes Shop",
                            items: [ RippedPants.new, Bucket.new,
                                     Parka.new, RiotShield.new ] })
    super(params)
  end
end
