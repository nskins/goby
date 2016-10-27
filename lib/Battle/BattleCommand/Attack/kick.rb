require_relative 'attack.rb'
require_relative 'kick.rb'
require_relative '../../../../lib/Entity/entity.rb'
require_relative '../../../../lib/Entity/player.rb'
require_relative '../../../../lib/Entity/Monster/monster.rb'
require_relative '../../../../lib/Entity/Monster/alien.rb'

# PRESET DATA
class Kick < Attack
  def initialize(params = { name: "Kick",
                            damage: 5,
                            success_rate: 99} )
    super(params)
  end

end

