require_relative '../lib/extension.rb'

RSpec.describe String do

  context "is positive?" do
    it "returns true for a positive string" do
      expect("y".is_positive?).to be true
      expect("yes".is_positive?).to be true
      expect("yeah".is_positive?).to be true
      expect("ok".is_positive?).to be true # okay, sure
    end

    it "returns false for a non-positive string" do
      expect("maybe".is_positive?).to be false
      expect("whatever".is_positive?).to be false
      expect("no".is_positive?).to be false
      expect("nah".is_positive?).to be false
    end
  end

  context "is negative?" do
    it "returns true for a negative string" do
      expect("n".is_negative?).to be true
      expect("no".is_negative?).to be true
      expect("nah".is_negative?).to be true
      expect("nope".is_negative?).to be true
    end

    it "returns false for a non-negative string" do
      expect("maybe".is_negative?).to be false
      expect("whatever".is_negative?).to be false
      expect("sure".is_negative?).to be false
      expect("okey dokey".is_negative?).to be false
    end
  end

end