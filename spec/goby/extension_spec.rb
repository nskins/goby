require 'goby'

RSpec.describe Array do
  context "nonempty?" do
    it "returns true when the array contains elements" do
      expect([1].nonempty?).to be true
      expect(["Hello"].nonempty?).to be true
      expect([false, false].nonempty?).to be true
    end

    it "returns false when the array contains no elements" do
      expect([].nonempty?).to be false
      expect(Array.new.nonempty?).to be false
    end
  end
end

RSpec.describe Integer do

  context "is positive?" do
    it "returns true for an integer value that is greater than zero" do
      expect(0.positive?).to be false
      expect(1.positive?).to be true
      expect(-1.positive?).to be false
    end
  end

  context "is nonpositive?" do
    it "returns true for an integer value less than or equal to zero" do
      expect(0.nonpositive?).to be true
      expect(1.nonpositive?).to be false
      expect(-1.nonpositive?).to be true
    end
  end

  context "is negative?" do
    it "returns true for an integer value less than zero" do
      expect(0.negative?).to be false
      expect(1.negative?).to be false
      expect(-1.negative?).to be true
    end
  end

  context "is nonnegative?" do
    it "returns true for an integer value greater than or equal to zero" do
      expect(0.nonnegative?).to be true
      expect(1.nonnegative?).to be true
      expect(-1.nonnegative?).to be false
    end
  end

end

RSpec.describe String do

  context "is positive?" do
    it "returns true for a positive string" do
      expect("y".is_positive?).to be true
      expect("yes".is_positive?).to be true
      expect("yeah".is_positive?).to be true
      expect("ok".is_positive?).to be true
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
