require 'goby'

RSpec.describe Music do

  include Music

  before(:all) do
    _relativePATH = File.expand_path File.dirname(__FILE__)
		@music = _relativePATH + "/bach.mid"
  end

  # If you do not have BGM support and would like to run the
  # test suite locally, replace 'it' with 'xit'.
  it "should play and stop the music" do
    set_playback(true)
    set_program("timidity")
    play_music(@music)
    sleep(0.01)
    stop_music
  end

end