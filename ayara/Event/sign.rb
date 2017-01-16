require_relative '../../lib/Event/event.rb'

class Sign < Event
  def initialize(mode: 0, visible: true)
    super(mode: mode, visible: visible)
    @command = "read"
  end
  
  def run(player)
    print "#{player.name} reads the sign...\n\n"
  end
end