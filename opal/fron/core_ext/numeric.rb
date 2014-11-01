# Numeric
class Numeric
  def clamp(min, max)
    [[self, max].min, min].max
  end

  def round(decimals = 0)
    `#{self}.toFixed(#{decimals})`.to_f
  end
end
