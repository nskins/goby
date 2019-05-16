# frozen_string_literal: true

module Goby

  # Methods for playing/stopping background music (BGM).
  module Music

    # Specify the program that should play the music.
    # Without overwriting, it is set to a default (see @@program).
    #
    # @param [String] name the name of the music-playing program.
    def set_program(name)
      @@program = name
    end

    # Specify if music should play or not.
    # May be useful to stop/start music for dramatic effect.
    #
    # @param [Boolean] flag true iff music should play.
    def set_playback(flag)
      @@playback = flag
    end

    # Starts playing the music from the specified file.
    # This has only been tested on Ubuntu w/ .mid files.
    #
    # @param [String] filename the file containing the music.
    def play_music(filename)
      return unless @@playback

      if (filename != @@file)
        stop_music
        @@file = filename

        # This thread loops the music until one calls #stop_music.
        @@thread = Thread.new {
          while (true)
            Process.wait(@@pid) if @@pid
            @@pid = Process.spawn("#{@@program} #{filename}", :out=>"/dev/null")
          end
        }
      end
    end

    # Kills the music process and the looping thread.
    def stop_music
      return unless @@playback

      Process.kill("SIGKILL", @@pid) if @@pid
      @@pid = nil

      @@thread.kill if @@thread
      @@thread = nil

      @@file = nil
    end

    @@file = nil
    @@pid = nil
    @@playback = false
    @@program = "timidity"
    @@thread = nil

  end

end