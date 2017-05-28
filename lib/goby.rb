# Main module of the framework.
module Goby
  # Version of the framework.
  VERSION = "0.1.0"
end

# Import order matters.

require 'i18n'
I18n.load_path = Dir["#{File.expand_path(File.dirname(__FILE__))}/goby/config/locales/*.yml"]

require 'goby/extension'
require 'goby/util'
require 'goby/world_command'
require 'goby/driver'

require 'goby/battle/battle_command'
require 'goby/battle/attack'
require 'goby/battle/escape'
require 'goby/battle/use'

require 'goby/map/map'
require 'goby/map/tile'

require 'goby/entity/entity'
require 'goby/entity/monster'
require 'goby/entity/player'

require 'goby/event/event'
require 'goby/event/npc'
require 'goby/event/shop'

require 'goby/item/item'
require 'goby/item/food'

require 'goby/item/equippable'
require 'goby/item/helmet'
require 'goby/item/legs'
require 'goby/item/shield'
require 'goby/item/torso'
require 'goby/item/weapon'
