class Event

  DEFAULT_RUN_TEXT = "Nothing happens.\n\n"

  # @param [String] command the command to activate the event.
  # @param [Integer] mode convenient way for an event to have multiple actions.
  # @param [Boolean] visible whether the event can be seen/activated.
  def initialize(command: "event", mode: 0, visible: true)
    @command = command

    # Can be used in a case statement in run for different outcomes.
    @mode = mode

    # The event can only be activated when this is true.
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
