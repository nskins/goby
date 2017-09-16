module Goby

  # A Player can interact with these on the Map.
  class Event

    # The default text for when the event doesn't do anything.
    DEFAULT_RUN_TEXT = "Nothing happens.\n\n"

    # @param [String] command the command to activate the event.
    # @param [Integer] mode convenient way for an event to have multiple actions.
    # @param [Boolean] visible true when the event can be seen/activated.
    def initialize(command: "event", mode: 0, visible: true)
      @command = command
      @mode = mode
      @visible = visible
    end

    # The function that runs when the player activates the event.
    # Override this function for subclasses.
    #
    # @param [Player] player the one activating the event.
    def run(player)
      print DEFAULT_RUN_TEXT
    end

    # @param [Event] rhs the event on the right.
    def ==(rhs)
      @command == rhs.command
    end

    # Specify the command in the subclass.
    attr_accessor :command, :mode, :visible

  end

end
