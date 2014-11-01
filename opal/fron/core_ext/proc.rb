# Proc
class Proc
  # Runs the given block after the given wait period
  # if called continously
  #
  # @param ms [Numeric] The wait period
  def throttle(ms)
    Native `throttle(#{self}, #{ms}, {leading: false})`
  end

  # Runs the given block after the given wait period
  # if called continously. The wait period restarts with each call
  #
  # @param ms [Numeric] The wait period
  def debounce(ms, leading = false)
    Native `debounce(#{self}, #{ms}, #{leading})`
  end
end
