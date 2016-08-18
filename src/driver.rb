require_relative "world_command.rb"

def run_driver(player)
  system("clear")

  unless player.map.nil?
    describe_tile(player)
    input = player_input
  end

  while (input.casecmp("quit") != 0)
    interpret_command(input, player)
    input = player_input
  end

end
