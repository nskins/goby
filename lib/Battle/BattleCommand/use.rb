require_relative 'battle_command.rb'

# Allows an Entity to use an Item in battle.
class Use < BattleCommand
  def initialize
    super(name: "Use")
  end

  # Uses the specified Item on the specified Entity.
  # Note that enemy is not necessarily on whom the Item is used.
  #
  # @param [Entity] user the one who is using the command.
  # @param [Entity] enemy the one on whom the command is used.
  def run(user, enemy)
    # Determine the item and on whom to use the item.
    pair = user.choose_item_and_on_whom(enemy)
    return if (!pair)
    user.use_item(pair.first, pair.second)
  end

  # Returns true iff the user's inventory is empty.
  #
  # @param [Entity] user the one who is using the command.
  # @return [Boolean] status of the user's inventory.
  def fails?(user)
    empty = user.inventory.empty?
    if empty
      print "#{user.name}'s inventory is empty!\n\n"
    end
    return empty
  end

end