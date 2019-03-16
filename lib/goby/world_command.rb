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
            status         Show player status
          use [item]      Use the specified item
          drop [item]        Drop the specified item
         equip [item]      Equip the specified item
        unequip [item]    Unequip the specified item
             save              Save the game
             quit               Quit the game

      }.freeze

    # String literal for the special commands header.
    SPECIAL_COMMANDS_HEADER = '* Special commands: '.freeze
    # Message for when the player tries to drop a non-existent item.
    NO_ITEM_DROP_ERROR = "You can't drop what you don't have!\n\n".freeze

    # Prints the commands that are available everywhere.
    def display_default_commands
      print DEFAULT_COMMANDS
    end

    # Prints the commands that are tile-specific.
    #
    # @param [Player] player the player who wants to see the special commands.
    def display_special_commands(player)
      events = player.location.map.tiles[player.location.coords.first][player.location.coords.second].events
      if events.any?(&:visible)
        print SPECIAL_COMMANDS_HEADER + events.select(&:visible).map(&:command).join(', ') + "\n\n"
      end
    end

    # Prints the default and special (tile-specific) commands.
    #
    # @param [Player] player the player who needs help.
    def help(player)
      display_default_commands
      display_special_commands(player)
    end

    # Describes the tile to the player after each move.
    #
    # @param [Player] player the player who needs the tile description.
    def describe_tile(player)
      tile = player.location.map.tiles[player.location.coords.first][player.location.coords.second]
      events = tile.events

      player.print_minimap
      print "#{tile.description}\n\n"
      display_special_commands(player)
    end

    # Handles the player's input and executes the appropriate action.
    #
    # @param [String] command the player's entire command input.
    # @param [Player] player the player using the command.
    def interpret_command(command, player)
      return if command.eql?('quit')

      words = command.split

      # Default commands that take multiple "arguments" (words).
      if words.size > 1

        # TODO: this chunk could be a private function.
        # Determine the name of the second "argument."
        name = words[1]
        for i in 2..(words.size - 1) do
          name << ' ' << words[i]
        end

        # Determine the appropriate command to use.
        # TODO: some of those help messages should be string literals.
        if words[0].casecmp('drop').zero?
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
            print NO_ITEM_DROP_ERROR
          end
          return
        elsif words[0].casecmp('equip').zero?
          player.equip_item(name); return
        elsif words[0].casecmp('unequip').zero?
          player.unequip_item(name); return
        elsif words[0].casecmp('use').zero?
          player.use_item(name, player); return
        end
      end

      # TODO: map command input to functions? Maybe this can
      #       also be done with the multiple-word commands?
      if command.casecmp('w').zero?
        player.move_up; return
      elsif command.casecmp('a').zero?
        player.move_left; return
      elsif command.casecmp('s').zero?
        player.move_down; return
      elsif command.casecmp('d').zero?
        player.move_right; return
      elsif command.casecmp('help').zero?
        help(player); return
      elsif command.casecmp('map').zero?
        player.print_map; return
      elsif command.casecmp('inv').zero?
        player.print_inventory; return
      elsif command.casecmp('status').zero?
        player.print_status; return
      elsif command.casecmp('save').zero?
        save_game(player, 'player.yaml'); return
      end

      # Other commands.
      events = player.location.map.tiles[player.location.coords.first][player.location.coords.second].events
      events.each do |event|
        if event.visible && words[0] && words[0].casecmp(event.command).zero?
          event.run(player)
          return
        end
      end

      # Text for incorrect commands.
      # TODO: Add string literal for this.
      puts "That isn't an available command at this time."
      print "Type 'help' for a list of available commands.\n\n"
    end
  end
end
