require 'goby'

module Goby
  # Allows an Entity to use an Item in battle.
  class Use < BattleCommand
    # Initializes the Use command.
    def initialize
      super(name: 'Use')
    end

    # Returns true iff the user's inventory is empty.
    #
    # @param [Entity] user the one who is using the command.
    # @return [Boolean] status of the user's inventory.
    def fails?(user)
      empty = user.inventory.empty?
      print "#{user.name}'s inventory is empty!\n\n" if empty
      empty
    end

    # Uses the specified Item on the specified Entity.
    # Note that enemy is not necessarily on whom the Item is used.
    #
    # @param [Entity] user the one who is using the command.
    # @param [Entity] enemy the one on whom the command is used.
    def run(user, enemy)
      user.choose_and_use_item_on(enemy)
    end
  end
end
