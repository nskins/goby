class BattleCommand

  def initialize(params = {})
    @name = params[:name] || "BattleCommand"
  end

  # Override this method.
  # Read as: "The user uses the command on its enemy."
  def run(user, enemy)
    print "Nothing happens.\n\n"
  end

  def ==(rhs)
    return (@name.casecmp(rhs.name) == 0)
  end

  def to_s
    @name
  end

  attr_accessor :name

end
