require_relative 'monster.rb'
require_relative '../../Battle/BattleCommand/Attack/kick.rb'

class Alien < Monster
  def initialize(params = {})
    super(params)
    @name = params[:name] || "Alien"
    @max_hp = hp = params[:max_hp] || 40
    @hp = params[:hp] || hp
    @attack = params[:attack] || 6
    @defense = params[:defense] || 2
    @battle_commands = params[:battle_commands] || [ Kick.new ]
    @gold = params[:gold] || 20
    @message = params[:message] || "\"I come from another world.\""
  end
end
