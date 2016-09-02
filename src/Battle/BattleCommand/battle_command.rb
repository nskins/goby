class BattleCommand

  # @param [Hash] params the parameters for creating a BattleCommand.
  # @option params [String] :name the name.
  def initialize(params = {})
    @name = params[:name] || "BattleCommand"
  end

  # The process that runs when this command is used in battle.
  # Override this function for subclasses.
  #
  # @param [Entity] user the one who is using the command.
  # @param [Entity] enemy the one on whom the command is used.
  def run(user, enemy)
    print "Nothing happens.\n\n"
  end

  # @param [BattleCommand] rhs the command on the right.
  def ==(rhs)
    return (@name.casecmp(rhs.name) == 0)
  end

  # @return [String] the name of the BattleCommand.
  def to_s
    @name
  end

  attr_accessor :name

end
