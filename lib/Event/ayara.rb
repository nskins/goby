require_relative 'house.rb'
require_relative '../Item/bucket.rb'
require_relative '../Item/recipe_book.rb'
require_relative '../Item/Food/egg.rb'
require_relative '../Item/Food/veggies.rb'

class MayorHouse < House
  def initialize
    super(name: "Mayor")
  end
  
  def run(player)
    super(player)
    
    type("#{@name}: What? Who are you?\n")
    type("SCRAM PUNK!\n\n")
    print "*SLAM!*\n\n"
  end
end

class SeliaHouse < House
  def initialize
    super(name: "Selia")
  end
  
  def run(player)
    super(player)
    
    if player.has_item(RecipeBook.new)
      type("#{@name}: How's that Recipe Book treating you?\n")
      type("Learn more recipes and become the greatest chef\n")
      type("of all time.\n\n")
    else
      type("#{@name}: Are you ready to take your cooking\n")
      type("skills to the next level (y/n)?: ")
      input = gets.chomp
      print "\n"
      
      if (input == 'y')
        type("#{@name}: Today, we will learn about recipes!\n")
        type("Each recipe requires specific ingredients.\n")
        type("Once you have obtained the appropriate ingredients,\n")
        type("simply cook the ingredients, and, hopefully, you\n")
        type("will have the tasty dish appear before your very eyes!\n\n")
        sleep(2)
        type("#{@name}: Here. Use this...\n\n")
        
        puts "Obtained Recipe Book!\n\n"
        
        book = RecipeBook.new
        s_eggs = Recipe.new(name: "Scrambled Eggs",
                            ingredients: [Couple.new(Egg.new, 2),
                                          Couple.new(Onion.new, 1),
                                          Couple.new(Pepper.new, 1)],
                            product: ScrambledEggs.new)
        book.add_recipe(s_eggs)
        player.add_item(book)
        sleep(2)
        
        type("#{@name}: I've already included a recipe. Try it out!\n\n")
      else
        print "*SLAM!*\n\n"
      end
    end
  end
  
end

class TimHouse < House
  def initialize
    super(name: "Tim's wife")
  end
  
  def run(player)
    super(player)
    
    if player.has_item(Bucket.new)
      type("#{@name}: AHA!!! So yer the one who took mah\n")
      type("watering contraption!? I've every right to report\n")
      type("ye to the authorities! Gimme that!\n\n")
      
      type("The Bucket is snatched away!\n\n")
      player.remove_item(Bucket.new)
    else
      type("#{@name}: Ye happen to see that lousy\n")
      type("ol' Tim hanging around somewhere? I tell ye\n")
      type("that man has no sense of responsibility!\n\n")
    end
  end
end

class Well < Event
  def initialize
    super(command: "fill")
  end
  
  def run(player)
    if player.has_item(Bucket.new)
      print "Will you fill the Bucket (y/n)?: "
      input = gets.chomp
      print "\n"
      
      if (input == 'y')
        puts "You attach the Bucket to the rope and feed it"
        puts "into the well. You pull the Bucket back up and"
        print "find that it's now filled with water.\n\n"
        player.remove_item(Bucket.new)
        player.add_item(BucketOfWater.new)
      end
    else
      print "You need some type of container!\n\n"
    end
  end
end