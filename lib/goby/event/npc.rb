require 'goby'

module Goby

  # A non-player character with whom the party can interact.
  # Always activated with the 'talk' command.
  class NPC < Event

    # @param [String] name the name.
    # @param [Integer] mode convenient way for a NPC to have multiple actions.
    # @param [Boolean] visible whether the NPC can be seen/activated.
    def initialize(name: "NPC", mode: 0, visible: true)
      super(mode: mode, visible: visible)
      @name = name
      @command = "talk"
    end

    # The function that runs when the party speaks to the NPC.
    #
    # @param [Party] party the one speaking to the NPC.
    def run(party)
      print "#{@name}: Hello!\n\n"
    end

    attr_accessor :name

  end

end