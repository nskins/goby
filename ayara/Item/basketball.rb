require_relative '../../lib/Item/item.rb'

class Basketball < Item
  def initialize
    super(name: "Basketball", consumable: false)
  end
  
  def use(user, entity)
    print "*dribble dribble*\n\n"
  end
end