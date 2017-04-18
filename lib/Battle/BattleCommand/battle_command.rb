class BattleCommand

  NO_ACTION = "Nothing happens.\n\n"

  # @param [String] name the name.
  def initialize(name: "BattleCommand")
    @name = name
  end

  # The process that runs when this command is used in battle.
  # Override this function for subclasses.
  #
  # @param [Entity] user the one who is using the command.
  # @param [Entity] entity the one on whom the command is used.
  def run(user, entity)
    print NO_ACTION
  end

  # This method can prevent the user from using this command
  # based on a defined condition. Override for subclasses.
  #
  # @param [Entity] user the one who is using the command.
  # @return [Boolean] true iff the command cannot be used.
  def fails?(user)
    false
  end

  # @param [BattleCommand] rhs the command on the right.
  # @return [Boolean] true iff the commands are considered equal.
  def ==(rhs)
    @name.casecmp(rhs.name).zero?
  end

  # @return [String] the name of the BattleCommand.
  def to_s
    @name
  end

  attr_accessor :name

end
