require_relative 'event.rb'

# PRESET DATA
class Box < Event

  def initialize(params = {})
    super(params)
    @command = "open"
    @gold = params[:gold] || 0
  end

  def run(player)
    puts "You rip open the box..."
    print "...and find #{@gold} gold inside!\n\n"
    player.gold += @gold
    @visible = false
  end

  attr_accessor :gold
end
