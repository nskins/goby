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

  attr_accessor :name, :description

end
