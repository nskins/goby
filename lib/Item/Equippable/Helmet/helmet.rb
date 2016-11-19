require_relative '../equippable.rb'

class Helmet < Equippable

  # @param [Hash] params the parameters for creating a Helmet.
  # @option params [String] :name the name.
  # @option params [Integer] :price the cost in a shop.
  # @option params [Boolean] :consumable determines whether the item is lost when used.
  # @option params [Hash] :stat_change the change in stats for when the item is equipped.
  def initialize(params = {})
    super(params)
    @name = params[:name] || "Helmet"
    @type = :helmet
  end

end
