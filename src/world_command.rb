# Functions that handle commands on the "world map."

def help(player)
  display_default_commands
  display_special_commands(player)
end

def display_default_commands
  puts "* Default commands:"
  puts "n (north); s (south);"
  puts "e (east); w (west);"
  puts "help; map; inv; use [item]"
  print "status; attacks\n\n" # TODO: merge attacks into status.
end

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

def print_possible_moves(player)
  y = player.location.first
  x = player.location.second

  puts "* Movement:"

  if player.map.tiles[y - 1][x].passable
    print "north (n); "
  end

  if player.map.tiles[y][x + 1].passable
    print "east (e); "
  end

  if player.map.tiles[y + 1][x].passable
    print "south (s); "
  end

  if player.map.tiles[y][x - 1].passable
    print "west (w);"
  end
  print "\n\n"
end

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
      index = player.has_item_by_string(name)
      if (index != -1)
        # TODO: Perhaps the player should be allowed to specify
        #       how many of the Item to drop.
        item = player.inventory[index].first
        player.remove_item(item, 1)
      else
        print "You can't drop what you don't have!\n\n"
      end
    when "unequip"
      player.unequip_item_by_string(name)
    when "use"
      player.use_item_by_string(name, player)
    end
    return
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
    player.print_player_map; return
  when "inv"
    print "Current gold in pouch: #{player.gold}.\n\n"
    puts "Your inventory:"
    player.print_inventory; return
  when "status"
    player.print_status; return
  when "attacks"
    player.print_attacks_with_stats; return
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
def describe_tile(player)
  tile = player.map.tiles[player.location.first][player.location.second]
  events = tile.events

  print "#{tile.description}\n\n"
  print_possible_moves(player)

  display_special_commands(player)
end
