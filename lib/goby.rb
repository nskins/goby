# Import order matters.

require_relative 'goby/scaffold'
require_relative 'goby/extension'
require_relative 'goby/util'
require_relative 'goby/world_command'
require_relative 'goby/music'
require_relative 'goby/driver'

require_relative 'goby/battle/battle'
require_relative 'goby/battle/battle_command'
require_relative 'goby/battle/attack'
require_relative 'goby/battle/escape'
require_relative 'goby/battle/use'

require_relative 'goby/map/map'
require_relative 'goby/map/tile'

require_relative 'goby/entity/entity'
require_relative 'goby/entity/fighter'
require_relative 'goby/entity/monster'
require_relative 'goby/entity/player'

require_relative 'goby/event/event'
require_relative 'goby/event/chest'
require_relative 'goby/event/npc'
require_relative 'goby/event/shop'

require_relative 'goby/item/item'
require_relative 'goby/item/food'

require_relative 'goby/item/equippable'
require_relative 'goby/item/helmet'
require_relative 'goby/item/legs'
require_relative 'goby/item/shield'
require_relative 'goby/item/torso'
require_relative 'goby/item/weapon'
