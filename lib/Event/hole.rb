require_relative 'event.rb'

# PRESET DATA
class Hole < Event
  def initialize(max_reward: 20)
    super(command: "dig")
    @max_reward = max_reward
    (@max_reward = 1) if (@max_reward < 1)
  end

  def run(player)
    if player.has_item("Shovel")

      reward = Random.rand(0..@max_reward)

      print "#{player.name} starts digging...\n\n"
      sleep(1)
      print "...and finds #{reward} gold!\n\n"

      player.gold += reward

      @visible = false
    else
      print "You'll need proper gardening equipment for that.\n\n"
    end
  end

  attr_accessor :max_reward
end
