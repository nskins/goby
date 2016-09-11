require_relative 'event.rb'

# PRESET DATA
class Hole < Event
  def initialize(params = {command: "dig"})
    super(params)
  end

  def run(player)
    if (player.has_item("Shovel") != -1)
      # @todo do something interesting for the preset game.

      print "#{player.name} tries digging, but nothing happens.\n\n"
    else
      print "You'll need proper gardening equipment for that.\n\n"
    end
  end
end
