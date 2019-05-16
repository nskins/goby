# frozen_string_literal: true

require 'goby'

module Goby

  # A chest containing gold and/or items.
  class Chest < Event

    # @param [Integer] mode convenient way for a chest to have multiple actions.
    # @param [Boolean] visible whether the chest can be seen/activated.
    # @param [Integer] gold the amount of gold in this chest.
    # @param [[Item]] treasures the items found in this chest.
    def initialize(mode: 0, visible: true, gold: 0, treasures: [])
      super(mode: mode, visible: visible)
      @command = "open"
      @gold = gold
      @treasures = treasures
    end

    # The function that runs when the player opens the chest.
    #
    # @param [Player] player the one opening the chest.
    def run(player)
      type("You open the treasure chest...\n\n")
      sleep(1) unless ENV['TEST']
      player.add_loot(@gold, @treasures)
      @visible = false
    end

    attr_reader :gold, :treasures

  end

end