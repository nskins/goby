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

    # Prints the commands that are tile-specific.
    #
    # @param [Player] player the player who wants to see the special commands.
    def display_special_commands(player)
      commands = tile(player).events.select(&:visible).map(&:command)
      print SPECIAL_COMMANDS_HEADER + commands.join(', ') + "\n\n" if commands.any?
    end

    # Prints the default and special (tile-specific) commands.
    #
    # @param [Player] player the player who needs help.
    def help(player)
      print DEFAULT_COMMANDS
      display_special_commands(player)
    end

    # Describes the tile to the player after each move.
    #
    # @param [Player] player the player who needs the tile description.
    def describe_tile(player)
      player.print_minimap
      print "#{tile(player).description}\n\n"
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
        # Determine the name of the second "argument."
        name = words[1..- 1].join(' ')

        # Determine the appropriate command to use.
        # TODO: some of those help messages should be string literals.
        commands = {
          'drop' => -> { player.drop_item(name) },
          'equip' => -> { player.equip_item(name) },
          'unequip' => -> { player.unequip_item(name) },
          'use' => -> { player.use_item(name, player) },
        }
        _cmd, action = commands.detect { |cmd, _action| words[0].casecmp?(cmd) }
        return action.call if action
      end

      # TODO: map command input to functions? Maybe this can
      #       also be done with the multiple-word commands?
      if command.casecmp?('w')
        return player.move_up
      elsif command.casecmp?('a')
        return player.move_left
      elsif command.casecmp?('s')
        return player.move_down
      elsif command.casecmp?('d')
        return player.move_right
      elsif command.casecmp?('help')
        return help(player)
      elsif command.casecmp?('map')
        return player.print_map
      elsif command.casecmp?('inv')
        return player.print_inventory
      elsif command.casecmp?('status')
        return player.print_status
      elsif command.casecmp?('save')
        return save_game(player, 'player.yaml')
      end

      # Other commands.
      tile(player).events.each do |event|
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

    private

    def tile(player)
      player.location.map.tiles[player.location.coords.first][player.location.coords.second]
    end
  end
end
