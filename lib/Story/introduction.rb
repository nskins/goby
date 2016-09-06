require_relative '../world_command.rb'

# PRESET DATA
# Prints how-to-play instructions if the user requires them.
def print_introduction
  print "Do you know how to play? (y/n): "
  input = gets.chomp
  print "\n"

  return if (input.casecmp('y') == 0)

  puts "Welcome to the Preset Game. This is a simple example"
  print "of what is possible using the Goby framework.\n\n"
  sleep(4)

  puts "In this world, your character responds to 'commands.'"
  print "These are the commands available everywhere:\n\n"

  display_default_commands

  puts "However, 'special commands' will also become available"
  print "in some locations.\n\n"
  sleep(12)

  puts "In battle, your character will use its HP, attack, and"
  puts "defense to defeat monsters. HP is the health - the player"
  puts "dies when it reaches 0. Attack defines how much damage"
  puts "is dealt when attacking. Defense defines how well one"
  print "can withstand these attacks.\n\n"
  sleep(12)

  puts "If you ever feel lost, just type 'help'."
  print "Well... off you go!\n\n"
  sleep(4)

end
