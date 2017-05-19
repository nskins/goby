require 'set'

# Provides additional methods for Array.
class Array
  def nonempty?
    return !empty?
  end
end

# Provides additional methods for Integer.
class Integer

  # Returns true if the integer is a positive number.
  def positive?
    return self > 0
  end

  # Returns true if the integer is not a positive number.
  def nonpositive?
    return self <= 0
  end

  # Returns true if the integer is a negative number.
  def negative?
    return self < 0
  end

  # Returns true if the integer is not a negative number.
  def nonnegative?
    return self >= 0
  end

end

# Provides additional methods for String.
class String

  # Set of all known positive responses.
  POSITIVE_RESPONSES = Set.new [ "ok", "okay", "sure", "y", "ye", "yeah", "yes" ]
  # Set of all known negative responses.
  NEGATIVE_RESPONSES = Set.new [ "n", "nah", "no", "nope" ]

  # Returns true iff the string is affirmative/positive.
  def is_positive?
    return POSITIVE_RESPONSES.include?(self)
  end

  # Returns true iff the string is negatory/negative.
  def is_negative?
    return NEGATIVE_RESPONSES.include?(self)
  end

end
