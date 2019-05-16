# frozen_string_literal: true

require 'goby'

module Goby

	# Can be worn in the Player's outfit.
	class Torso < Item
		include Equippable

	  # @param [String] name the name.
	  # @param [Integer] price the cost in a shop.
	  # @param [Boolean] consumable determines whether the item is lost when used.
	  # @param [Boolean] disposable allowed to sell or drop item when true.
	  # @param [Hash] stat_change the change in stats for when the item is equipped.
	  def initialize(name: "Torso", price: 0, consumable: false, disposable: true, stat_change: {})
	    super(name: name, price: price, consumable: consumable, disposable: disposable)
	    @type = :torso
	    @stat_change = stat_change
	  end

	  attr_reader :type, :stat_change
	end

end