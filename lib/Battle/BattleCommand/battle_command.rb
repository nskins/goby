class BattleCommand

  # @param [String] name the name.
  # @param [String] description a summary/message of its purpose.
  def initialize(name: "BattleCommand", description: nil)
    @name = name
    @description = description
  end

  # The process that runs when this command is used in battle.
  # Override this function for subclasses.
  #
  # @param [Entity] user the one who is using the command.
  # @param [Entity] entity the one on whom the command is used.
  def run(user, entity)
    print "Nothing happens.\n\n"
  end
  
  # This method can prevent the user from using this command
  # based on a defined condition. Override for subclasses.
  #
  # @param [Entity] user the one who is using the command.
  # @return [Boolean] true iff the command cannot be used.
  def fails?(user)
    return false
  end

  # @param [BattleCommand] rhs the command on the right.
  def ==(rhs)
    return (@name.casecmp(rhs.name) == 0)
  end

  # @return [String] the name of the BattleCommand.
  def to_s
    @name
  end

  attr_accessor :name, :description

end
