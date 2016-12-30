require_relative 'event.rb'

class House < Event
  def initialize(mode: 0, visible: true, name: "NPC")
    super(mode: mode, visible: visible)
    @command = "knock"
    @name = name
  end
  
  def run(player)
    type("#{player.name} knocks at the door...\n\n")
    sleep(2)
  end
  
  # Name of the person who answers the door.
  attr_accessor :name
end