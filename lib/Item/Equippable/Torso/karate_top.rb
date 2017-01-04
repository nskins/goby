require_relative 'torso.rb'

class KarateTop < Torso
  def initialize
    super(name: "Karate Top", price: 30, stat_change: {agility: 2})
  end
end