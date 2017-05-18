module Goby

  # Functions that handle commands on the "world map."
  module WorldCommand

    # String literal providing default commands.
    DEFAULT_COMMANDS =
  %{     Command          Purpose

        w (↑)
  a (←) s (↓) d (→)       Movement

          help      Show the help menu
         map       Print the map
          inv         Check inventory
     [who] status       Show player/party status
      drop <item>        Drop the item
    <who> use <item>       Use the item
   <who> equip <item>       Equip the item
    <who> unequip <item>     Unequip the item
          save              Save the game
           quit            Quit the game

  }

    # String literal for the special commands header.
    SPECIAL_COMMANDS_HEADER = "* Special commands: "
    # Message for when no such command is available.
    NO_COMMAND_ERROR = "That isn't an available command at this time."\
                       "Type 'help' for a list of available commands.\n\n"
    # Message for when the party tries to drop a non-existent item.
    NO_ITEM_DROP_ERROR = "You can't drop what you don't have!\n\n"
    # Message for when no such party member exists.
    def NO_PARTY_MEMBER_ERROR(name)
      "There's nobody in the party named #{name}!"
    end

    # Prints the commands that are available everywhere.
    def display_default_commands
      print DEFAULT_COMMANDS
    end

    # Prints the commands that are tile-specific.
    #
    # @param [Party] party the party who wants to see the special commands.
    def display_special_commands(party)
      events = party.map.tiles[party.location.first][party.location.second].events
      if (!(events.empty?) && events.any? { |event| event.visible })

        print SPECIAL_COMMANDS_HEADER + (events.reduce([]) do |commands, event|
          commands << event.command if event.visible
          commands
        end.join(', ')) + "\n\n"
      end
    end

    # Prints the default and special (tile-specific) commands.
    #
    # @param [Party] party the party who needs help.
    def help(party)
      display_default_commands
      display_special_commands(party)
    end

    # Describes the tile to the party after each move.
    #
    # @param [Party] party the party who needs the tile description.
    def describe_tile(party)
      tile = party.map.tiles[party.location.first][party.location.second]
      events = tile.events

      party.print_minimap
      print "#{tile.description}\n\n"
      display_special_commands(party)
    end

    # Handles the party's input and executes the appropriate action.
    #
    # @param [String] input the party's entire command input.
    # @param [Party] party the party using the command input.
    def interpret_command(input, party)
      words = input.split

      # Display error message for empty strings.
      if words[0].nil?
        print NO_COMMAND_ERROR
        return
      end

      # Determine if this is a player-specific command input.
      player_index = party.has_member(words[0])
      if player_index
        player = party.members[player_index]
        command = words[1]
        item = concat_words(words, 2)

        # Error handling.
        if (command.nil? || (item.nil? && command.casecmp("status").nonzero?))
          print NO_COMMAND_ERROR
          return
        end

        if command.casecmp("equip").zero?
          party.equip_item(item, player); return
        elsif command.casecmp("status").zero?
          player.print_status; return
        elsif command.casecmp("unequip").zero?
          party.unequip_item(item, player); return
        elsif command.casecmp("use").zero?
          party.use_item(item, player); return
        end
      end

      if words[0].casecmp("drop").zero?
        item = concat_words(words, 1)
        index = party.has_item(item)

        # Error handling for non-existent item.
        if index.nil?
          print NO_ITEM_DROP_ERROR
        elsif !party.inventory[index].first.disposable
          print "You cannot drop that item.\n\n"
        else
          # TODO: Perhaps the party should be allowed to specify
          #       how many of the Item to drop.
          item = party.inventory[index].first
          party.remove_item(item, 1)
          print "You have dropped #{item}.\n\n"
        end
        return
      end

      # TODO: map command input to functions? Maybe this can
      #       also be done with the multiple-word commands?
      if input.casecmp("w").zero?
        party.move_up; return
      elsif input.casecmp("a").zero?
        party.move_left; return
      elsif input.casecmp("s").zero?
        party.move_down; return
      elsif input.casecmp("d").zero?
        party.move_right; return
      elsif input.casecmp("help").zero?
        help(party); return
      elsif input.casecmp("map").zero?
        party.print_map; return
      elsif input.casecmp("inv").zero?
        party.print_inventory; return
      elsif input.casecmp("status").zero?
        party.print_status; return
      elsif input.casecmp("save").zero?
        save_game(party, "party.yaml"); return
      end

      # Other commands.
      events = party.map.tiles[party.location.first][party.location.second].events
      events.each do |event|
        if (event.visible && words[0] && words[0].casecmp(event.command).zero?)
          event.run(party)
          return
        end
      end

      # Error text for unavailable commands.
      print NO_COMMAND_ERROR

    end
  end

  # TODO: Ruby Array function that does something like this?
  # Concatenates the members of 'array' with a space
  # in between each, starting at 'start_index'.
  #
  # @param [[String]] array the array in question.
  # @param [Integer] start_index the index at which to start.
  # @return [String] the concatenated result.
  def concat_words(array, start_index)
    return if array[start_index].nil?
    result = array[start_index]
    for i in (start_index + 1)..(array.size - 1) do
      result << " " << array[i]
    end
    return result
  end

end