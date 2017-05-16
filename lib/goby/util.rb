require 'readline'
require 'yaml'

module Goby

  # Stores a pair of values.
  class Couple

    # @param [Object] first the first object in the pair.
    # @param [Object] second the second object in the pair.
    def initialize(first, second)
      @first = first
      @second = second
    end

    # @param [Couple] rhs the couple on the right.
    def ==(rhs)
      return ((@first == rhs.first) && (@second == rhs.second))
    end

    attr_accessor :first, :second
  end

  # Simple player input script.
  #
  # @param [Boolean] lowercase mark true if input should be returned lowercase.
  # @param [String] prompt the prompt for the user to input information.
  # @param [Boolean] doublespace mark false if extra space should not be printed after input.
  def player_input(lowercase: true, prompt: '', doublespace: true)

    # When using Readline, rspec actually prompts the user for input, freezing the tests.
    print prompt
    input = (ENV['TEST'] == 'rspec') ? gets.chomp : Readline.readline(" \b", false)
    puts "\n" if doublespace

    if ((input.size > 1) and (input != Readline::HISTORY.to_a[-1]))
      Readline::HISTORY.push(input)
    end

    return lowercase ? input.downcase : input
  end

  # Prints text as if it were being typed.
  #
  # @param [String] message the message to type out.
  def type(message)

    # Amount of time to sleep between printing character.
    time = ENV['TEST'] ? 0 : 0.015

    # Sleep between printing of each char.
    message.split("").each do |i|
      sleep(time) if time.nonzero?
      print i
    end
  end

  # Serializes the party object into a YAML file and saves it
  #
  # @param [Party] party the party object to be saved.
  # @param [String] filename the name under which to save the file.
  def save_game(party, filename)
    party_data = YAML::dump(party)
    File.open(filename, "w") do |file|
      file.puts party_data
    end
    print "Successfully saved the game!\n\n"
    return
  end

  # Reads and check the save file and parses into the party object.
  #
  # @param [String] filename the file containing the save data.
  # @return [Party] the party corresponding to the save data.
  def load_game(filename)
    begin
      party = YAML.load_file(filename)
      return party
    rescue
      return nil
    end
  end

end