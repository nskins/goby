require 'goby'

RSpec.describe Event do
  
  context "constructor" do
    it "has the correct default parameters" do
      event = Event.new
      expect(event.command).to eq "event"
      expect(event.mode).to eq 0
      expect(event.visible).to eq true
    end

    it "correctly assigns custom parameters" do
      box = Event.new(command: "open",
                      mode: 1,
                      visible: false)
      expect(box.command).to eq "open"
      expect(box.mode).to eq 1
      expect(box.visible).to eq false
    end
  end

  context "run" do
    it "prints the default run text for a default event" do
      event = Event.new
      entity = Entity.new
      expect { event.run(entity) }.to output(Event::DEFAULT_RUN_TEXT).to_stdout
    end
  end

end
