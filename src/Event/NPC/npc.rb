require_relative '../event.rb'

class NPC < Event

  # @param [Hash] params the parameters for creating a NPC.
  # @option params [String] :name the name.
  # @option params [Integer] :mode convenient way for a NPC to have multiple actions.
  # @option params [Boolean] :visible whether the NPC can be seen/activated.
  def initialize(params = {})
    super(params)
    @name = params[:name] || "NPC"
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
