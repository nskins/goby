require_relative 'battle_command.rb'

# PRESET DATA
class Use < BattleCommand
  def initialize
    super(name: "Use", description: "    Use an item.\n")
  end

  # Uses the specified item on the specified Entity.
  #
  # @param [Entity] user the one who is using an item.
  # @param [Entity] specified the enemy in this battle.
  def run(user, enemy)
    pair = user.choose_item_and_on_whom(enemy)
    return if (!pair)
    user.use_item(pair.first, pair.second)
  end
  
  # Returns true if and only if the user's inventory is empty.
  #
  # @param [Entity] user the one who is using the command.
  # @return [Boolean] status of the user's inventory.
  def fails(user)
    empty = user.inventory.empty?
    if empty
      puts "#{user.name}'s inventory is empty!\n\n"
    end
    return empty
  end

end