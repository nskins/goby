require 'goby'

RSpec.describe do

  let(:player) { Player.new }

  # Success for each of these tests mean
  # that run_driver exits without error.
  context "run driver" do
    it "should exit on 'quit'" do
      __stdin("quit\n") { run_driver(player) }
    end

    it "should accept various commands in a looping fashion" do
      __stdin("w\ne\ns\nn\nquit\n") { run_driver(player) }
    end
  end
end
