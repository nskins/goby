require_relative 'food.rb'

class Donut < Food

  def initialize(params = {})
    super(params)
    @name = "Donut"
    @price = 10
    @recovers = 15
  end

end
