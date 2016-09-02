class Event

  # @param [Hash] params the parameters for creating an Event.
  # @option params [String] :command the command to activate the event.
  # @option params [Integer] :mode convenient way for an event to have multiple actions.
  # @option params [Boolean] :visible whether the event can be seen/activated.
  def initialize(params = {})
    @command = params[:command] || "event"

    # Can be used in a case statement in run for different outcomes.
    @mode = params[:mode] || 0

    # The event can only be activated when this is true.
    if params[:visible].nil? then @visible = true
    else @visible = params[:visible] end
  end

  # The function that runs when the player activates the event.
  # Override this function for subclasses.
  #
  # @param [Player] player the one activating the event.
  def run(player)
    print "Nothing happens.\n\n"
  end

  # @param [Event] rhs the event on the right.
  def ==(rhs)
    @command == rhs.command
  end

  # Specify the command in the subclass.
  attr_accessor :command
  attr_accessor :mode
  attr_accessor :visible

end
