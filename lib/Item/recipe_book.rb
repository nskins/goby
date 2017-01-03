require_relative 'item.rb'

class RecipeBook < Item
  def initialize
    super(name: "Recipe Book", price: 0, consumable: false)
    @recipes = []
  end
  
  def use(user, entity)
    print_recipes
  end
  
  def add_recipe(recipe)
    @recipes << recipe
    @recipes.sort!{ |x,y| x.name <=> y.name }
  end
  
  def print_recipes
    if @recipes.empty?
      print "The Recipe Book is empty!\n\n"
    else
      print "** Recipe Book:\n\n"
      @recipes.each do |recipe|
        puts "* #{recipe.name}:"
        recipe.ingredients.each do |ingredient|
          puts "#{ingredient.first} (#{ingredient.second})"
        end
        print "\n"
      end
    end
  end
  
  # Array<Recipe>
  attr_accessor :recipes
end

class Recipe
  def initialize(name: "Recipe", ingredients: [])
    @name = name
    @ingredients = ingredients
  end
  
  # String
  attr_accessor :name
  
  # Array<Couple(Item, Integer)>
  attr_accessor :ingredients
end