require_relative 'entity.rb'
require_relative 'item.rb'

# entity.rb and item.rb don't need to include one another!
def no_include_entity
  e = Entity.new("")
  e.add_item(Banana.new, 1)
  puts e.has_item_by_string("Banana")
end

no_include_entity
