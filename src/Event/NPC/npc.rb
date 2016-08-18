require_relative '../event.rb'

class NPC < Event

  def initialize(params = {})
    super(params)
    @name = params[:name] || "NPC"
    @command = "talk"
  end

  # Override what happens when the player interacts with the NPC.
  def run(player)
    puts "Hello!"
  end

  attr_accessor :name

end
