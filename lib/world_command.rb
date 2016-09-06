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
  puts "n (north); s (south);"
  puts "e (east); w (west);"
  puts "help; map; inv;"
  puts "use [item]; drop [item]"
  puts "equip [item]; unequip [item];"
  print "status; attacks; quit\n\n" # TODO: merge attacks into status.
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

  puts "* Movement:"

  if y > 0 && tiles[y - 1][x].passable
    print "north (n); "
  end

  if x < (tiles[y].length-1) && tiles[y][x + 1].passable
    print "east (e); "
  end

  if y < (tiles.length-1) && tiles[y + 1][x].passable
    print "south (s); "
  end

  if x > 0 && tiles[y][x - 1].passable
    print "west (w);"
  end
  print "\n\n"
end

# Handles the player's input and executes the appropriate action.
#
# @param [String] command the player's entire command input.
# @param [Player] player the player using the command.
def interpret_command(command, player)
  words = command.split.map(&:downcase)

  # Default commands that take multiple "arguments" (words).
  if (words.size > 1)

    # Determine the name of the second "argument."
    name = words[1]
    for i in 2..(words.size - 1) do
      name << " " << words[i]
    end

    # Determine the appropriate command to use.
    case(words[0])
    when "drop"
      index = player.has_item(name)
      if (index != -1)
        # TODO: Perhaps the player should be allowed to specify
        #       how many of the Item to drop.
        item = player.inventory[index].first
        player.remove_item(item, 1)
      else
        print "You can't drop what you don't have!\n\n"
      end
      return
    when "equip"
      player.equip_item(name); return
    when "unequip"
      player.unequip_item(name); return
    when "use"
      player.use_item(name, player); return
    end
  end

  # Single-word default commands.
  case(command)
  when "n"
    player.move_north; return
  when "e"
    player.move_east; return
  when "s"
    player.move_south; return
  when "w"
    player.move_west; return
  when "help"
    help(player); return
  when "map"
    player.print_map; return
  when "inv"
    player.print_inventory; return
  when "status"
    player.print_status; return
  when "attacks"
    # TODO: fix the function.
    # player.print_attacks_with_stats
    print "TODO: fix print_attacks_with_stats\n\n"
    return
  end

  # Other commands.
  events = player.map.tiles[player.location.first][player.location.second].events
  events.each do |event|
    if (event.visible && words[0] == event.command)
      event.run(player)
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
