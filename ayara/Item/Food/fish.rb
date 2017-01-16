require_relative '../bait.rb'

class RawBluegill < Baitable
  def initialize
    super(name: "Raw Bluegill", price: 4, 
          cooked: Bluegill.new, bait: Snail.new)
  end
end

class Bluegill < Food
  def initialize
    super(name: "Bluegill", price: 8, recovers: 6)
  end
end