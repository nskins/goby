require_relative 'attack.rb'

# PRESET DATA
class Smash < Attack

  def initialize(params = { name: "Smash",
                            damage: 10,
                            success_rate: 80 } )
    super(params)
  end

end
