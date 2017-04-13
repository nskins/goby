def get_name
  print "Brave hero, what is thy name?: "
  input = gets.chomp.downcase
  print "\n"
  return input
end

def load_game?
  system("clear")

  print "Would you like to load the saved game (y/n)?: "
  input = gets.chomp.downcase
  print "\n"
  
  return true if input == 'y'
  return false
end

def print_intro
  system("clear")
  
  print "Do you know how to play (y/n)?: "
  input = gets.chomp.downcase
  print "\n"
  
  return if input != 'n'
  
  puts "First things first - interaction"
  puts "is handled by commands. Here are some"
  print "of the most important ones:\n\n"
  
  sleep(4)
  
  print "     Command        Purpose\n\n"
  puts  "      w (↑)"
  puts  "a (←) s (↓) d (→)   Movement"
  puts
  puts  "       map          View the map"
  puts  "      help          See ALL commands"
  puts  "       inv          Check inventory"
  print "   use [item]       Use an item\n\n"
  
  print "Press enter to continue..."
  gets
  
  puts "\nAlso, it's necessary to stress that"
  print "exploration is key.\n\n"
  
  sleep(2)
  
  puts "Try out different things!"
  
  sleep(2)
end
