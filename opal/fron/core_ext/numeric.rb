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

  # Rounds itself to the given number of decimals
  #
  # @param decimals [Numeric] The number of decimals
  #
  # @return [Float] The rounded value
  def round(decimals = 0)
    `#{self}.toFixed(#{decimals})`.to_f
  end
end
