require 'goby'

module Goby
  # Allows an Entity to try to escape from the opponent.
  class Escape < BattleCommand
    # Text for successful escape.
    SUCCESS = "Successful escape!\n\n".freeze
    # Text for failed escape.
    FAILURE = "Unable to escape!\n\n".freeze

    # Initializes the Escape command.
    def initialize
      super(name: 'Escape')
    end

    # Samples a probability to determine if the user will escape from battle.
    #
    # @param [Entity] user the one who is trying to escape.
    # @param [Entity] enemy the one from whom the user wants to escape.
    def run(user, enemy)
      user.escape_from(enemy)
      type(user.escaped ? SUCCESS : FAILURE)
    end
  end
end
