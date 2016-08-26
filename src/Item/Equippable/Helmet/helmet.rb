require_relative '../equippable.rb'

class Helmet < Equippable

  def initialize(params = {})
    super(params)
    @name = params[:name] || "Helmet"
    @type = :helmet
  end

end
