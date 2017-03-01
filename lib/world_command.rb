# coding: utf-8
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
  puts "     Command          Purpose"
  puts
  puts "      w (↑)"
  puts "a (←) s (↓) d (→)        Movement"
  puts
  puts "        help      Show the help menu"
  puts "       map       Print the map"
  puts "        inv         Check inventory"
  puts "      status         Show player status"
  puts "    use [item]      Use the specified item"
  puts "    drop [item]        Drop the specified item"
  puts "   equip [item]      Equip the specified item"
  puts "  unequip [item]    Unequip the specified item"
  puts "       save              Save the game"
  print "       quit               Quit the game\n\n"
end

# Prints the commands that are tile-specific.
#
# @param [Player] player the player who wants to see the special commands.
def display_special_commands(player)
  events = player.map.tiles[player.location.first][player.location.second].events
  if (!(events.empty?) && events.any? { |event| event.visible })

    print "* Special commands: " + (events.reduce([]) do |commands, event|
      commands << event.command if event.visible
      commands
    end.join(', ')) + "\n\n"
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
      if index && !player.inventory[index].first.disposable
        print "You cannot drop that item.\n\n"
      elsif index
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
  elsif command.casecmp("save").zero?
    save_game(player); return
  end

  # Other commands.
  events = player.map.tiles[player.location.first][player.location.second].events
  events.each do |event|
    if (event.visible && words[0] && words[0].casecmp(event.command).zero?)
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

  player.print_minimap

  print "#{tile.description}\n\n"
  # print_possible_moves(player)

  display_special_commands(player)
end
