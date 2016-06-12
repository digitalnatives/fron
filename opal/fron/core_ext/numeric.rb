# Numeric
class Numeric
  # Clamps itself between two values
  #
  # @param min [Numeric] The minimum value
  # @param max [Numeric] The maximum value
  #
  # @return [Numeric] The clamped value
  def clamp(min, max)
    [[self, max].min, min].max
  end

  # Returns the px representation
  #
  # @return [String] The px
  def px
    "#{round}px"
  end

  # Returns the em representation
  #
  # @return [String] The em
  def em
    "#{self}em"
  end
end
