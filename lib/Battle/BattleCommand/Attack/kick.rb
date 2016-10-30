require_relative 'attack.rb'

# PRESET DATA
class Kick < Attack
  def initialize(params = { name: "Kick",
                            damage: 5,
                            success_rate: 99} )
    super(params)
  end

end

