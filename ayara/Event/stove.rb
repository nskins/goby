require_relative '../../lib/Event/event.rb'
require_relative '../Item/cookable.rb'
require_relative '../Item/recipe_book.rb'

class Stove < Event
  def initialize
    super(command: "cook")
  end

  def run(player)
    puts "You can cook either a single item or a recipe."

    input = player_input prompt: "What would you like to cook?: "
    item_index = player.has_item(input)
    book_index = player.has_item(RecipeBook.new)
    recipe_index = player.inventory[book_index].first.has_recipe(input) if book_index

    recipe = nil

    # Error handling for bad input.
    if !recipe_index
      if !item_index
        print "What?! You can't cook THAT!\n\n"
        return
      elsif (defined?(player.inventory[item_index].first.cooked).nil?)
        print "You can't cook #{player.inventory[item_index].first.name}!\n\n"
        return
      end

      # Construct a recipe.
      recipe = Recipe.new(ingredients: [Couple.new(player.inventory[item_index].first, 1)],
                          product: player.inventory[item_index].first.cooked)
    end

    # Use the recipe found in the Recipe Book.
    recipe = player.inventory[book_index].first.recipes[recipe_index] if recipe_index

    input = player_input prompt: "How many?: ", doublespace: false
    amount = input.to_i

    # Error handling for non-positive amount.
    if (amount <= 0)
      print "\nYou must choose a positive amount!\n\n"
      return
    end

    if (!has_enough_ingredients?(player, recipe, amount))
      print "\nYou don't have enough ingredients!\n\n"
    else
      success = 0
      failure = 0
      amount.times do
        random = [true, false].sample
        (success = success + 1) if random
        (failure = failure + 1) unless random
      end
      # Some nice output about the results.
      puts "\nResults:"
      puts "* #{recipe.product.name} (#{success})"
      print "* Burnt Flub (#{failure})\n\n"

      # Add and remove items as appropriate.
      player.add_item(recipe.product, success) if (success > 0)
      player.add_item(BurntFlub.new, failure) if (failure > 0)
      remove_ingredients(player, recipe, amount)
    end
  end

  private

    # Returns true iff the player has enough ingredients.
    def has_enough_ingredients?(player, recipe, amount)
      recipe.ingredients.each do |ing|
        index = player.has_item(ing.first)
        return false if !index
        return false if (player.inventory[index].second < (ing.second * amount))
      end
      return true
    end

    # Removes each ingredient by the appropriate
    # amount called for in the recipe.
    def remove_ingredients(player, recipe, amount)
      recipe.ingredients.each do |ing|
        player.remove_item(ing.first, ing.second * amount)
      end
    end
end
