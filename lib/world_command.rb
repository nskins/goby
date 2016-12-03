require_relative "driver.rb"
# require_relative "Battle/BattleCommand/escape.rb"
# require_relative "Battle/BattleCommand/Attack/kick.rb"
require_relative "Entity/player.rb"
require_relative "Map/Map/map.rb"
# require_relative "Map/Map/donut_field.rb"


# Functions that handle commands on the "world map."

# Prints the default and special (tile-specific) commands.
#
# @param [Player] player the player who needs help.
def help(player)
  display_default_commands
  display_special_commands(player)
end

# Prints the commands that are available everywhere.
def display_default_commands
  puts "* Default commands:"
  puts "w (↑); a (←); s (↓); d(→);"
  puts "help; map; inv; status;"
  puts "use [item]; drop [item]"
  puts "equip [item]; unequip [item];"
  print "quit\n\n"
end

# Prints the commands that are tile-specific.
#
# @param [Player] player the player who wants to see the special commands.
def display_special_commands(player)
  events = player.map.tiles[player.location.first][player.location.second].events
  if (!(events.empty?) && events.any? { |event| event.visible })

    # Use the counter so there are only 4 commands per line.
    counter = 0
    puts "* Special commands:"
    events.each do |event|
      # Print the corresponding command and increment the counter.
      if (event.visible)
        print "#{event.command}; "
        counter += 1
      end

      # Restart the counter and print a newline.
      if (counter == 4)
        counter = 0
        print "\n"
      end
    end

    print "\n"
    if (counter != 0)
      print "\n"
    end

  end
end

# Prints the available cardinal directions to which the player can move.
#
# @param [Player] player the player who needs to see the possible moves.
def print_possible_moves(player)
  y = player.location.first
  x = player.location.second
  tiles = player.map.tiles

  print "* Movement: "

  if x > 0 && tiles[y][x - 1].passable
    print "← "
  end

  if y > 0 && tiles[y - 1][x].passable
    print "↑ "
  end

  if y < (tiles.length-1) && tiles[y + 1][x].passable
    print "↓ "
  end

  if x < (tiles[y].length-1) && tiles[y][x + 1].passable
    print "→ "
  end

  print "\n\n"
end

# Handles the player's input and executes the appropriate action.
#
# @param [String] command the player's entire command input.
# @param [Player] player the player using the command.
def interpret_command(command, player)
  words = command.split()

  # Default commands that take multiple "arguments" (words).
  if (words.size > 1)

    # Determine the name of the second "argument."
    name = words[1]
    for i in 2..(words.size - 1) do
      name << " " << words[i]
    end

    # Determine the appropriate command to use.
    if words[0].casecmp("drop").zero?
      index = player.has_item(name)
      if (index != -1)
        # TODO: Perhaps the player should be allowed to specify
        #       how many of the Item to drop.
        item = player.inventory[index].first
        player.remove_item(item, 1)
        print "You have dropped #{item}.\n\n"
      else
        print "You can't drop what you don't have!\n\n"
      end
      return
    elsif words[0].casecmp("equip").zero?
      player.equip_item(name); return
    elsif words[0].casecmp("unequip").zero?
      player.unequip_item(name); return
    elsif words[0].casecmp("use").zero?
      player.use_item(name, player); return
    end
  end

  # Single-word default commands.
  if command.casecmp("w").zero?
    player.move_up; return
  elsif command.casecmp("a").zero?
    player.move_left; return
  elsif command.casecmp("s").zero?
    player.move_down; return
  elsif command.casecmp("d").zero?
    player.move_right; return
  elsif command.casecmp("help").zero?
    help(player); return
  elsif command.casecmp("map").zero?
    player.print_map; return
  elsif command.casecmp("inv").zero?
    player.print_inventory; return
  elsif command.casecmp("status").zero?
    player.print_status; return
  end

  # Other commands.
  events = player.map.tiles[player.location.first][player.location.second].events
  events.each do |event|
    if (event.visible && words[0] && words[0].casecmp(event.command).zero?)
      player.map.play_music(false)
      event.run(player)
      player.map.play_music(true)
      return
    end
  end

  # Text for incorrect commands.
  puts "That isn't an available command at this time."
  print "Type 'help' for a list of available commands.\n\n"

end

# Describes the tile to the player after each move.
#
# @param [Player] player the player who needs the tile description.
def describe_tile(player)
  tile = player.map.tiles[player.location.first][player.location.second]
  events = tile.events

  print "#{tile.description}\n\n"
  print_possible_moves(player)

  display_special_commands(player)
end
