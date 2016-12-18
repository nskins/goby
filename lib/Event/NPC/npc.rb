require_relative '../event.rb'

class NPC < Event

  # @param [String] name the name.
  # @param [Integer] mode convenient way for a NPC to have multiple actions.
  # @param [Boolean] visible whether the NPC can be seen/activated.
  def initialize(name: "NPC", mode: 0, visible: true)
    super(mode: mode, visible: visible)
    @name = name
    @command = "talk"
  end

  # The function that runs when the player speaks to the NPC.
  #
  # @param [Player] player the one speaking to the NPC.
  def run(player)
    puts "Hello!"
  end

  attr_accessor :name

end
