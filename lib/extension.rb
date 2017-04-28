require 'set'

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