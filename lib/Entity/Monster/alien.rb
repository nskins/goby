require_relative 'monster.rb'
require_relative '../../Battle/BattleCommand/Attack/kick.rb'

# PRESET DATA
class Alien < Monster
  def initialize(params = {})
    super(params)
    @name = "Alien"
    @max_hp = @hp = 30
    @attack = 6
    @defense = 2
    @agility = 2
    @battle_commands = [ Kick.new ]
    @gold = 20
    @message = "\"I come from another world.\""
  end
end