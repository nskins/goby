def print_intro
  system("clear")
  
  print "Do you know how to play (y/n)?: "
  input = gets.chomp
  print "\n"
  
  return if input != 'n'
  
  puts "First things first. Commands are"
  puts "really helpful sometimes. Some of"
  print "the important ones are as follows:\n\n"
  
  sleep(4)
  
  print "     Command        Purpose\n\n"
  puts  "      w (↑)"
  puts  "a (←) s (↓) d (→)   Movement"
  puts
  puts  "       map          View the map"
  puts  "      help          See all commands"
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