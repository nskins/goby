class Event

  def initialize(params = {})
    @command = params[:command] || "event"

    # Can be used in a case statement in run for different outcomes.
    @mode = params[:mode] || 0

    # The event can only be activated when this is true.
    if params[:visible].nil? then @visible = true
    else @visible = params[:visible] end
  end

  def run(player)
    print "Nothing happens.\n\n"
  end

  def ==(rhs)
    @command == rhs.command
  end

  # Specify the command in the subclass.
  attr_accessor :command, :mode, :visible

end
