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
  # @param [Boolean] lowercase mark true if response should be returned lowercase.
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

  # Serializes the player object into a YAML file and saves it
  #
  # @param [Player] player the player object to be saved.
  # @param [String] filename the name under which to save the file.
  def save_game(player, filename)
    player_data = YAML::dump(player)
    File.open(filename, "w") do |file|
      file.puts player_data
    end
    print "Successfully saved the game!\n\n"
    return
  end

  # Reads and check the save file and parses into the player object
  #
  # @param [String] filename the file containing the save data.
  # @return [Player] the player corresponding to the save data.
  def load_game(filename)
    begin
      player = YAML.load_file(filename)
      return player
    rescue
      return nil
    end
  end

  # Starts playing the music from the specified file.
  # This has only been tested on Ubuntu w/ .mid files.
  #
  # @param [String] filename the file containing the music.
  def play_music(filename)
    if (filename != $music_file)
      stop_music
      $music_pid = Process.spawn("timidity #{filename}", :out=>"/dev/null")
      $music_file = filename
    end
  end

  # If any music is playing, kills that process.
  def stop_music
    Process.kill("SIGKILL", $music_pid) if $music_pid
    $music_pid = nil
    $music_file = nil
  end

end